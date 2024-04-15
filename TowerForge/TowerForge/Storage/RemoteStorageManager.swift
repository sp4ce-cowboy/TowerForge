//
//  RemoteStorageManager.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation
import FirebaseDatabaseInternal

/// A utility class to provide standard storage operations and interaction with
/// the Firebase Database.
///
/// Currently the Storage means is limited to storing Statistics only, possible
/// expansion to a generic types can be considered.
class RemoteStorageManager {
    static var currentPlayer: String = Constants.CURRENT_PLAYER_ID
    static var currentDevice: String = Constants.CURRENT_DEVICE_ID

    static func initializeRemoteStatisticsDatabase() {
        Self.loadDatabaseFromFirebase { statisticsDatabase, error in
            if let error = error {
                Logger.log("Error initializing data: \(error)", self)
                return
            }

            if statisticsDatabase != nil {
                Logger.log("Statistics database already initialized.", self)
                return
            }
        }

        // No error but no database implies that database is empty, thus initialize new one
        Logger.log("No error and empty database, new one will be created", self)
        var remoteStorage = StatisticsFactory.getDefaultStatisticsDatabase()

        Self.saveDatabaseToFirebase(remoteStorage) { error in
            if let error = error {
                Logger.log("Saving to firebase error: \(error)", self)
            } else {
                Logger.log("Saving to firebase success", self)
            }
        }
    }

    /// Queries the firebase backend to determine if remote storage exists for the current player
    static func remoteStorageExistsForCurrentPlayer(completion: @escaping (Bool) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        databaseReference.child(currentPlayer).getData(completion: { error, snapshot in
            if let error = error {
                Logger.log("Error checking data existence: \(error.localizedDescription)", self)
                completion(false) // Assuming no data exists if an error occurs
                return
            }

            if snapshot?.exists() != nil && snapshot?.value != nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }

    static func loadDatabaseFromFirebase(completion: @escaping (StatisticsDatabase?, Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        databaseReference.child(currentPlayer).getData(completion: { error, snapshot in
            if let error = error {
                Logger.log(error.localizedDescription, self)
                completion(nil, error)
                return
            }

            guard let value = snapshot?.value as? [String: Any],
                  let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else {
                completion(nil, nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let statsDatabase = try decoder.decode(StatisticsDatabase.self, from: jsonData)
                completion(statsDatabase, nil)
            } catch {
                Logger.log("Error decoding StatisticsDatabase from Firebase: \(error)", self)
                completion(nil, error)
            }
        })
    }

    static func saveDatabaseToFirebase(_ stats: StatisticsDatabase, completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stats)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

            databaseReference.child(currentPlayer).setValue(dictionary) { error, _ in
                if let error = error {
                    Logger.log("StatisticsDatabase could not be saved: \(error).", StatisticsDatabase.self)
                    completion(error)
                } else {
                    Logger.log("StatisticsDatabase saved to Firebase successfully!", StatisticsDatabase.self)
                    completion(nil)
                }
            }
        } catch {
            Logger.log("Error encoding StatisticsDatabase: \(error)", StatisticsDatabase.self)
            completion(error)
        }
    }

    /// Deletes the player's statistics database from Firebase
    static func deleteDatabaseFromFirebase(completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        // Remove the data at the specific currentPlayer node
        databaseReference.child(currentPlayer).removeValue { error, _ in
            if let error = error {
                Logger.log("Error deleting data: \(error).", self)
                completion(error)
                return
            }
            Logger.log("StatisticsDatabase for player \(currentPlayer) successfully deleted from Firebase.", self)
            completion(nil)
        }
    }
}
