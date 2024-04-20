//
//  RemoteStroage.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

/// Utility class to provide static methods for accessing remote storage
class RemoteStorage {

    private init() { }

    /// Queries the firebase backend to determine if remote storage exists for the current player
    static func remoteStorageExists(for ref: FirebaseReference,
                                    player: String,
                                    completion: @escaping (Bool) -> Void) {
        let databaseReference = FirebaseDatabaseReference(ref)

        databaseReference.child(player).getData(completion: { error, snapshot in
            if let error = error {
                Logger.log("Error checking data existence: \(error.localizedDescription)", self)
                completion(false) // Assuming no data exists if an error occurs
                return
            }

            // Snapshot must exist AND be non-empty in order to be considered existing
            if snapshot?.exists() != nil && snapshot?.value != nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }

    /// Saves the input StorageDatabase to firebase
    static func saveDataToFirebase(for ref: FirebaseReference,
                                   player: String,
                                   with inputData: StorageDatabase,
                                   completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(ref)

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(inputData)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

            databaseReference.child(player).setValue(dictionary) { error, _ in
                if let error = error {
                    Logger.log("Data could not be saved: \(error).", Self.self)
                    completion(error)
                } else {
                    Logger.log("Data saved to Firebase successfully!", Self.self)
                    completion(nil)
                }
            }
        } catch {
            Logger.log("Error encoding Data: \(error)", Self.self)
            completion(error)
        }
    }

    /// Saves the input StorageDatabase to firebase
    static func deleteDataFromFirebase(for ref: FirebaseReference,
                                       player: String,
                                       completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(ref)

        // Remove the data at the specific player node
        databaseReference.child(player).removeValue { error, _ in
            if let error = error {
                Logger.log("Error deleting data: \(error).", self)
                completion(error)
                return
            }

            Logger.log("Data for player \(player) successfully deleted from Firebase.", self)
            completion(nil)
        }
    }

    static func loadDataFromFirebase<T: StorageDatabase>(for ref: FirebaseReference,
                                                         player: String,
                                                         completion: @escaping (T?, Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(ref)

        databaseReference.child(player).getData(completion: { error, snapshot in
            if let error = error {
                Logger.log("Error loading data from firebase: \(error.localizedDescription)", self)
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
                let storageDatabase = try decoder.decode(T.self, from: jsonData)
                completion(storageDatabase, nil)
            } catch {
                Logger.log("Error decoding StatisticsDatabase from Firebase: \(error)", self)
                completion(nil, error)
            }
        })
    }

}
