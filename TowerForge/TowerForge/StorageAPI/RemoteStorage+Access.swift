//
//  RemoteStorage+Metadata.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

/// This class adds utility methods specifically for access operations. Given
/// the nature of the remote backend, closures are used for async operations.
/// This class abstracts away the closure invocation with default access
/// functions, for both storage and metadata.
extension RemoteStorage {

    static func checkIfPlayerMetadataExistsAsync(for playerId: String) async -> Bool {
        await withCheckedContinuation { continuation in
            Self.remoteStorageExists(for: .Metadata, player: playerId) { exists in
                continuation.resume(returning: exists)
            }
        }
    }

    static func checkIfRemotePlayerDataExists(playerId: String, completion: @escaping (Bool) -> Void) {
        // Check for player storage existence
        RemoteStorage.checkIfPlayerDatabaseExists(for: playerId) { storageExists in
            // Check for player metadata existence
            RemoteStorage.checkIfPlayerMetadataExists(for: playerId) { metadataExists in
                // Check for any inconsistencies
                if (storageExists && !metadataExists) || (!storageExists && metadataExists) {
                    Logger.log("Inconsistency error: Storage Exists: \(storageExists), Metadata Exists: \(metadataExists)")
                }

                // Return the combined result
                completion(storageExists && metadataExists)
            }
        }
    }

    /// Checks if a player's metadata exists
    static func checkIfPlayerMetadataExists(for playerId: String,
                                            completion: @escaping (Bool) -> Void) {

        Self.remoteStorageExists(for: .Metadata, player: playerId, completion: completion)
    }

    /// Checks if a player's statistics exists
    static func checkIfPlayerDatabaseExists(for playerId: String,
                                            completion: @escaping (Bool) -> Void) {

        Self.remoteStorageExists(for: .Statistics, player: playerId, completion: completion)
    }

    /// Checks if a player's statistics exists without requiring a closure input

    static func saveMetadataToFirebase(player: String,
                                       with inputData: Metadata,
                                       completion: @escaping (Bool) -> Void) {
        let metadataCompletion: (Error?) -> Void = { error in
            if let error = error {
                Logger.log("Saving metadata to firebase error: \(error)", self)
                completion(false)
            } else {
                Logger.log("Saving metadata to firebase success", self)
                completion(true)
            }
        }

        Self.saveDataToFirebase(for: .Metadata,
                                player: player,
                                with: inputData,
                                completion: metadataCompletion)
    }

    static func saveDatabaseToFirebase(player: String,
                                       with inputData: StatisticsDatabase,
                                       completion: @escaping (Bool) -> Void) {
        let storageCompletion: (Error?) -> Void = { error in
            if let error = error {
                Logger.log("Saving storage to firebase error: \(error)", self)
                completion(false)
            } else {
                Logger.log("Saving storage to firebase success", self)
                completion(true)
            }
        }

        Self.saveDataToFirebase(for: .Statistics,
                                player: player,
                                with: inputData,
                                completion: storageCompletion)
    }

    /// Deletes metadata for the specified player from firebase
    static func deleteMetadataFromFirebase(player: String) {
        let completion: (Error?) -> Void = { error in
            if let error = error {
                Logger.log("Deleting metadata from firebase error: \(error)", self)
            } else {
                Logger.log("Deleting Metadata from firebase success", self)
            }
        }

        Self.deleteDataFromFirebase(for: .Metadata, player: player, completion: completion)
    }

    /// Deletes storage for the specific player from Firebase
    static func deleteDatabaseFromFirebase(player: String) {
        let completion: (Error?) -> Void = { error in
            if let error = error {
                Logger.log("Deleting storage from firebase error: \(error)", self)
            } else {
                Logger.log("Saving storage from firebase success", self)
            }
        }

        Self.deleteDataFromFirebase(for: .Statistics, player: player, completion: completion)
    }

    static func loadMetadataFromFirebase(player: String,
                                         completion: @escaping (Metadata?, Error?) -> Void) {
        Self.checkIfPlayerDatabaseExists(for: player) { exists in
            guard exists else {
                completion(nil, nil) // Consider custom error
                return
            }

            Self.loadDataFromFirebase(for: .Metadata, player: player) { (metadata: Metadata?, error: Error?) in
                completion(metadata, error)
            }
        }
    }

    static func loadDatabaseFromFirebase(player: String,
                                        completion: @escaping (StatisticsDatabase?, Error?) -> Void) {
        Self.checkIfPlayerDatabaseExists(for: player) { exists in
            guard exists else {
                completion(nil, nil) // Consider custom error
                return
            }

            Self.loadDataFromFirebase(for: .Statistics,
                                      player: player) { (statistics: StatisticsDatabase?, error: Error?) in
                completion(statistics, error)
            }
        }
    }

    /*static func loadStorageFromFirebase(player: String) -> StatisticsDatabase? {
        guard Self.checkIfPlayerStorageExists(for: player) else {
            return nil
        }

        var stats: StatisticsDatabase?
        Self.loadDataFromFirebase(for: .Statistics,
                                  player: player) { (statisticsDatabase: StatisticsDatabase?, error: Error?) in
            if let error = error {
                Logger.log("Error loading storage from firebase: \(error)", self)
            } else if let statistics = statisticsDatabase {
                Logger.log("Successfully loaded statistics from firebase", self)
                stats = statistics
            } else {
                // No error and no database implies that database is empty, return nil
                Logger.log("No error and empty database, new one will NOT be auto-created", self)
            }
        }

        return stats
    }

    static func loadMetadataFromFirebase(player: String) async -> Metadata? {
        guard await Self.checkIfPlayerMetadataExistsAsync(for: player) else {
            return nil
        }

        var metadata: Metadata?
        Self.loadDataFromFirebase(for: .Statistics,
                                  player: player) { (remoteMetadata: Metadata?, error: Error?) in
            if let error = error {
                Logger.log("Error loading storage from firebase: \(error)", self)
            } else if let currentMetadata = remoteMetadata {
                Logger.log("Successfully loaded statistics from firebase", self)
                metadata = currentMetadata
            } else {
                // No error and no database implies that database is empty, return nil
                Logger.log("No error and empty database, new one will NOT be auto-created", self)
            }
        }

        return metadata
    }*/
}
