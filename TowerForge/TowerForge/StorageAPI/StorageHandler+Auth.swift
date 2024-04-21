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

            if !Self.isLoggedIn {
                Self.isLoggedIn = true
                // Asynchronously check if remote data exists for currentPlayerId
                self.checkIfRemotePlayerDataExists { exists in
                    if exists {
                        Logger.log("ONLOGIN ---- REMOTE PLAYER DATA EXISTS")
                        self.onReLogin { reloginSuccess in
                            if !reloginSuccess {
                                Logger.log("RE-LOGIN FAILED: Remote player exists but Re-login failure", self)
                            }
                        }
                    } else {
                        Logger.log("ONLOGIN ---- REMOTE PLAYER DATA DOESN'T EXIST")
                        self.onFirstLogin()
                    }
                }
            }
        }
    }

    /// Helper function to asynchronously check if both Metadata and Storage exist
    func checkIfRemotePlayerDataExists(completion: @escaping (Bool) -> Void) {
        RemoteStorage.checkIfRemotePlayerDataExists(playerId: Self.currentPlayerId, completion: completion)
    }

    func onFirstLogin() {
        Logger.log("FIRST LOGIN ENTERED", self)
        self.save()
    }

    /// Returns true if re-login success, false otherwise
    func onReLogin(completion: @escaping (Bool) -> Void) {
        Logger.log("RE-LOGIN ENTERED", self)
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
                Self.resolveConflict(this: self.statisticsDatabase, that: remoteStorage) { resolvedStats in
                    Logger.log("ONRELOGIN --- THIS DB is \(String(describing: self.statisticsDatabase.toString()))", self)
                    Logger.log("ONRELOGIN --- THAT DB is \(String(describing: remoteStorage.toString()))", self)
                    guard let finalStorage = resolvedStats else {
                        Logger.log("RELOGIN ERROR: CONFLICT RESOLUTION FAILURE")
                        completion(false)
                        return
                    }

                    // 4. Update current instance to resolve storage
                    self.statisticsDatabase = finalStorage

                    // 5. Save newly resolved storage universally
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
        Self.isLoggedIn = false
        Constants.CURRENT_PLAYER_ID = Constants.CURRENT_DEVICE_ID
        Logger.log("LOGOUT: CALLED FROM STORAGE_HANDLER", Self.self)
        self.save() // Save any potential unsaved changes
        metadata.resetIdentifier() // Reset metadata to original value
        Logger.log("LOGOUT: metadata reset to \(metadata.uniqueIdentifier)", Self.self)
        self.localSave() // Save updated metadata
    }
}
