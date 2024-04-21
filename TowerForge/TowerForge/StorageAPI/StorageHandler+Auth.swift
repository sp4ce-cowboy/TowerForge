//
//  StorageHandler+Auth.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

/// This extension adds authentication methods to StorageHandler
extension StorageHandler {
    /*func onLogin() {
        Task {
            onAsyncLogin()
        }
    }*/

    func onLogin() {
        Logger.log("LOGIN: IS CALLED FROM STORAGE HANDLER", Self.self)

        authenticationProvider.getCurrentUserId { [weak self] userId, error in
            guard let self = self else {
                return
            }

            if let error = error {
                Logger.log("IMPT: onLogin failed from STORAGE_HANDLER: \(error.localizedDescription)", self)
                return
            }

            guard let userId = userId else {
                Logger.log("IMPT: onLogin failed due to userId nil from STORAGE_HANDLER", self)
                return
            }

            // Update the playerId and metadata locally
            self.localUpdatePlayerIdAndMetadata(with: userId)

            // Asynchronously check if remote data exists for currentPlayerId
            self.checkIfRemotePlayerDataExists { exists in
                if exists {
                    self.onReLogin { reloginSuccess in
                        if !reloginSuccess {
                            Logger.log("RE-LOGIN FAILED: Remote player exists but Re-login failure", self)
                        }
                    }
                } else {
                    self.onFirstLogin()
                }
            }
        }
    }

    /// Helper function to asynchronously check if both Metadata and Storage exist
    func checkIfRemotePlayerDataExists(completion: @escaping (Bool) -> Void) {
        RemoteStorage.checkIfRemotePlayerDataExists(playerId: Self.currentPlayerId, completion: completion)
    }

    func onFirstLogin() {
        self.remoteSave()
    }

    /// Returns true if re-login success, false otherwise
    func onReLogin(completion: @escaping (Bool) -> Void) {
        // Executed upon confirmation that both types of data exist remotely
        // 1. Load metadata from firebase
        RemoteStorage.loadMetadataFromFirebase(player: Self.currentPlayerId) { remoteMetadata, _ in
            guard let remoteMetadata = remoteMetadata else {
                Logger.log("RELOGIN ERROR: REMOTE METADATA NOT FOUND")
                completion(false)
                return
            }

            // 2. Load statistics from firebase
            RemoteStorage.loadDatabaseFromFirebase(player: Self.currentPlayerId) { remoteStorage, _ in
                guard let remoteStorage = remoteStorage else {
                    Logger.log("RELOGIN ERROR: REMOTE STORAGE NOT FOUND")
                    completion(false)
                    return
                }

                // 3. Resolve conflict between remote statistics and current statistics
                Self.resolveConflict(this: remoteStorage, that: self.statisticsDatabase) { resolvedStats in
                    guard let finalStorage = resolvedStats else {
                        Logger.log("RELOGIN ERROR: CONFLICT RESOLUTION FAILURE")
                        completion(false)
                        return
                    }

                    // 4. Update current instance to resolve storage
                    self.statisticsDatabase = finalStorage

                    // 4. Save newly resolved storage universally
                    self.save()
                }
            }
        }
    }

    func localUpdatePlayerIdAndMetadata(with userId: String) {
        Constants.CURRENT_PLAYER_ID = userId
        metadata.updateIdentifierToCurrentID()
        self.localSave()
    }

    func onLogout() {
        Constants.CURRENT_PLAYER_ID = Constants.CURRENT_DEVICE_ID
        Logger.log("LOGOUT: CALLED FROM STORAGE_HANDLER", Self.self)
        self.save() // Save any potential unsaved changes
        metadata.resetIdentifier() // Reset metadata to original value
        Logger.log("LOGOUT: metadata reset to \(metadata.uniqueIdentifier)", Self.self)
        self.localSave() // Save updated metadata
    }

    /// Returns true if re-login success, false otherwise
    /*func onReLogin() -> Bool {
        // Fetch metadata
        guard let remoteMetadata = RemoteStorage.loadMetadataFromFirebase(player: Self.currentPlayerId) else {
            Logger.log("RELOGIN ERROR: REMOTE METADATA NOT FOUND")
            return false
        }

        // Fetch storage
        guard let remoteStorage = RemoteStorage.loadDatabaseFromFirebase(player: Self.currentPlayerId) else {
            Logger.log("RELOGIN ERROR: REMOTE STORAGE NOT FOUND")
            return false
        }

        var finalStorage = StatisticsDatabase.merge(this: remoteStorage, that: statisticsDatabase)

        // Merge storage - MERGE
        // Merge metadata - KEEP LATEST
        // Set storage to merged storage
        // Save new storage to file
        // Universal save will automatically update metadata
        // Universal save to remote

        return true

    }*/

    /*func onReLoginAsync() async -> Bool {
        do {
            // Fetch metadata and storage asynchronously
            let remoteMetadata = try await RemoteStorage.loadMetadataFromFirebase(player: Self.currentPlayerId)
            let remoteStorage = try await RemoteStorage.loadDatabaseFromFirebase(player: Self.currentPlayerId)

            // Merge storage - assume a static merge function in StatisticsDatabase
            let finalStorage = StatisticsDatabase.merge(this: remoteStorage, that: statisticsDatabase)

            // Save merged storage locally and remotely
            LocalStorage.saveDatabaseToLocal(finalStorage)  // Assuming there's a method to save locally
            try await RemoteStorage.saveDatabaseToFirebase(player: Self.currentPlayerId, with: finalStorage)

            // Update metadata locally and remotely
            // Assuming newer metadata is better or merge strategy is implemented
            metadata = remoteMetadata
            try await RemoteStorage.saveMetadataToFirebase(player: Self.currentPlayerId, with: metadata)

            return true
        } catch {
            Logger.log("RELOGIN ERROR: \(error)")
            return false
        }
    }*/
}
