//
//  RemoteStorage+Metadata.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

/// This class adds utility methods specifically for Metadata operations
extension RemoteStorage {

    /// Checks if a player's metadata exists without requiring a closure input
    static func checkIfPlayerMetadataExists(for playerId: String) -> Bool {
        var exists = false

        RemoteStorage.remoteStorageExists(for: .Metadata, player: playerId) { bool in
            exists = bool
        }

        return exists
    }
}
