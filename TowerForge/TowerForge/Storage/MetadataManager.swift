//
//  MetadataManager.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

class MetadataManager {

    /// Utility function that returns the StorageLocation indicator for the location that
    /// contains the most recent data.
    ///
    /// This is to be used in circumstances where simple merging cannot work, like in the
    /// case of Statistics database. Metadata's comformance to comparable allows for the
    /// comparision metric to be determined.
    ///
    /// Representation invariant is that the Metadata being compared contain the same
    /// uuid identifier.
    static func getLocationWithLatestMetadata() -> StorageLocation? {
        var remoteMetadataExists = false
        var localMetadataExists = false

        var remoteMetadata: Metadata?
        let localMetadata = LocalMetadataManager.loadMetadataFromLocalStorage()

        RemoteMetadataManager.remoteMetadataExistsForCurrentPlayer { remoteMetadataExists = $0 }
        localMetadataExists = localMetadata != nil

        /* --- Accounting for edge cases --- */

        // A nil value will automatically imply inferiority to any given value
        guard remoteMetadataExists || localMetadataExists else {
            return nil
        }

        if remoteMetadataExists && !localMetadataExists {
            return .Remote
        }

        if !remoteMetadataExists && localMetadataExists {
            return .Local
        }
        /* ------------------------------- */

        // The check above will ensure that the metadata file exists remotely, thus,
        // there is no need to account for the case where the metadata might be missing.
        RemoteMetadataManager.loadMetadataFromFirebase { metadata, error in
            if error != nil {
                Logger.log("Error occured at retriving metadata")
                return
            }

            remoteMetadata = metadata
        }

        guard let remoteMetadata = remoteMetadata, let localMetadata = localMetadata else {
            return nil
        }

        return remoteMetadata > localMetadata ? .Remote : .Local
    }
}
