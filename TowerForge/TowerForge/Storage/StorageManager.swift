//
//  StorageManager.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// The class responsible for providing application wide Storage access and
/// synchronizing between Local Storage and Remote Storage
class StorageManager: AuthenticationDelegate {
    func onLogout() {

    }

    func onLogin() {

    }

    static func resetAllStorage() {
        Self.deleteAllRemoteStorage()
        Self.deleteAllLocalStorage()
    }

    static func deleteAllLocalStorage() {
        LocalStorageManager.deleteDatabaseFromLocalStorage()
        MetadataManager.deleteMetadataFromLocalStorage()
    }

    static func deleteAllRemoteStorage() {
        RemoteStorageManager.deleteFromFirebase { error in
            if let error = error {
                Logger.log("Failed to delete user data: \(error)", self)
            } else {
                Logger.log("User data deleted, proceeding with logout", self)
            }
        }
    }

}
