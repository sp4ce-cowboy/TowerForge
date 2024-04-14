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

    static func loadFromFirebase(completion: @escaping (StatisticsDatabase?, Error?) -> Void) {
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

    static func saveToFirebase(_ stats: StatisticsDatabase, completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stats)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

            databaseReference.child(currentPlayer).setValue(dictionary) { error, _ in
                if let error = error {
                    Logger.log("Data could not be saved: \(error).", StatisticsDatabase.self)
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
    static func deleteFromFirebase(completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        // Remove the data at the specific currentPlayer node
        databaseReference.child(currentPlayer).removeValue { error, _ in
            if let error = error {
                Logger.log("Error deleting data: \(error).", self)
                completion(error)
                return
            }
            Logger.log("Data for player \(currentPlayer) successfully deleted from Firebase.", self)
            completion(nil)
        }
    }
}

extension RemoteStorageManager {
    static func loadFromFirebaseOld(completion: @escaping (StatisticsDatabase?, Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        databaseReference.child(currentPlayer).getData(completion: { error, snapshot in
            if let error = error {
                Logger.log(error.localizedDescription, self)
                completion(nil, error)
                return
            }

            guard let value = snapshot?.value as? [String: Any] else {
                completion(nil, nil)
                return
            }

            var statistics = [StatisticTypeWrapper: Statistic]()

            for (key, statisticValue) in value {
                guard let statisticDict = statisticValue as? [String: Any],
                      let statisticData = try? JSONSerialization.data(withJSONObject: statisticDict, options: []) else {
                    continue
                }

                do {
                    guard let statisticType = key.asTFClassFromString as? Statistic.Type else {
                        continue
                    }
                    let statisticName = statisticType.asType
                    let decoder = JSONDecoder()

                    let statistic: Statistic? = try StatisticsFactory
                                                        .defaultStatisticDecoder[statisticName]?(decoder, statisticData)
                    if let stat = statistic { statistics[statisticName] = stat }
                } catch {
                    Logger.log("Error decoding from Firebase \(key):, \(error)", self)
                }
            }

            let statsDatabase = StatisticsDatabase(statistics)
            completion(statsDatabase, nil)
        })
    }

    static func saveToFirebaseOld(_ stats: StatisticsDatabase, completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Statistics)
        var statisticsDictionary = [String: Any]()

        for (name, statistic) in stats.statistics {
            do {
                let data = try JSONEncoder().encode(statistic)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                statisticsDictionary[name.asString] = dictionary
            } catch {
                Logger.log("Error encoding statistic \(name): \(error)", StatisticsDatabase.self)
            }
        }

        databaseReference.child(currentPlayer).setValue(statisticsDictionary) { error, _ in
            if let error = error {
                Logger.log("Data could not be saved: \(error).", StatisticsDatabase.self)
            } else {
                Logger.log("StatisticsDatabase saved to Firebase successfully!", StatisticsDatabase.self)
            }
            completion(error)
        }
    }
}
