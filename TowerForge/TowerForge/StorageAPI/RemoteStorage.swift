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

    /// Checks if a player's statistics exists without requiring a closure input
    static func checkIfPlayerStorageExists(for playerId: String) -> Bool {
        var exists = false

        RemoteStorage.remoteStorageExists(for: .Statistics, player: playerId) { bool in
            exists = bool
        }

        return exists
    }

}
