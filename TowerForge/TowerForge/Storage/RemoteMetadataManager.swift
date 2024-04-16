//
//  RemoteMetadataManager.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation
import FirebaseDatabaseInternal

class RemoteMetadataManager {
    static var currentPlayer: String = Constants.CURRENT_PLAYER_ID
    static var currentDevice: String = Constants.CURRENT_DEVICE_ID

    /// Queries the firebase backend to determine if remote metadata exists for the current player
    static func remoteMetadataExistsForCurrentPlayer(completion: @escaping (Bool) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Metadata)

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

    static func initializeRemoteMetadata() {
        Self.loadMetadataFromFirebase { metadata, error in
            if let error = error {
                Logger.log("Error initializing metadata: \(error)", self)
                return
            }

            if let metadata = metadata {
                Logger.log("Metadata database already initialized : \(metadata)", self)
                return
            }

            // No error but no metadata implies that metadata is empty, thus initialize new one
            Logger.log("No error but empty metadata, new one will be created", self)
            let remoteMetadata = Metadata(lastUpdated: Date.now, uniqueIdentifier: Constants.CURRENT_PLAYER_ID)

            Self.saveMetadataToFirebase(remoteMetadata) { error in
                if let error = error {
                    Logger.log("Saving metadata to firebase error: \(error)", self)
                } else {
                    Logger.log("Saving metadata to firebase success", self)
                }
            }
        }
    }

    static func updateMetadataInFirebase() {
        var existingRemoteMetadata = Metadata(lastUpdated: Date.now,
                                              uniqueIdentifier: Constants.CURRENT_PLAYER_ID)

        Self.loadMetadataFromFirebase { metadata, error in
            if let error = error {
                Logger.log("Error occured while loading metadata from firebase for update --- \(error)", self)
                return
            }

            if let metadata = metadata {
                existingRemoteMetadata = metadata
            }
        }

        existingRemoteMetadata.lastUpdated = Date.now
        Logger.log("Metadata updated at: \(String(describing: existingRemoteMetadata.lastUpdated))", self)

        Self.saveMetadataToFirebase(existingRemoteMetadata) { error in
            if let error = error {
                Logger.log("Error occured while saving metadata to firebase for update --- \(error)", self)
                return
            }
        }
    }

    static func loadMetadataFromFirebase(completion: @escaping (Metadata?, Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Metadata)

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
                let metadata = try decoder.decode(Metadata.self, from: jsonData)
                completion(metadata, nil)
            } catch {
                Logger.log("Error decoding Metadata from Firebase: \(error)", self)
                completion(nil, error)
            }
        })
    }

    static func saveMetadataToFirebase(_ stats: Metadata, completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Metadata)

        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(stats)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

            databaseReference.child(currentPlayer).setValue(dictionary) { error, _ in
                if let error = error {
                    Logger.log("Metadata could not be saved: \(error).", Metadata.self)
                    completion(error)
                } else {
                    Logger.log("Metadata saved to Firebase successfully!", Metadata.self)
                    completion(nil)
                }
            }
        } catch {
            Logger.log("Error encoding StatisticsDatabase: \(error)", Metadata.self)
            completion(error)
        }
    }

    static func deleteMetadataFromFirebase(completion: @escaping (Error?) -> Void) {
        let databaseReference = FirebaseDatabaseReference(.Metadata)

        // Remove the data at the specific currentPlayer node
        databaseReference.child(currentPlayer).removeValue { error, _ in
            if let error = error {
                Logger.log("Error deleting data: \(error).", self)
                completion(error)
                return
            }
            Logger.log("Metadata for player \(currentPlayer) successfully deleted from Firebase.", self)
            completion(nil)
        }
    }
}
