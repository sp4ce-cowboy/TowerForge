//
//  LocalMetadataManager.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// This extension allows the LocalStorageManager to facilitate metadata storage
/// and loading functionality.
///
/// A custom Metadata class is implemented to provide more nuanced control over
/// metadata storage as opposed to using FileAttributesKey, although the option
/// to retrieve iOS-defined metadata is still available via a custom method.
class LocalMetadataManager {

    static let folderName = Constants.LOCAL_STORAGE_CONTAINER_NAME
    static let metadataFileName = Constants.METADATA_FILE_NAME
    static let fileManager = FileManager.default

    static func initializeUserIdentifier() {
        let metadata = LocalMetadataManager.checkAndCreateMetadata()
        Constants.CURRENT_PLAYER_ID = metadata.uniqueIdentifier
        Constants.CURRENT_DEVICE_ID = metadata.uniqueIdentifier
        Logger.log("Current player set to \(Constants.CURRENT_PLAYER_ID)", self)
        RemoteMetadataManager.initializeRemoteMetadata()
    }

    static func checkAndCreateMetadata() -> Metadata {
        if let existingMetadata = loadMetadataFromLocalStorage() {
            Logger.log("Existing metadata loaded", self)
            return existingMetadata
        } else {
            let newMetadata = Metadata()
            Logger.log("New metadata being created", self)
            saveMetadataToLocalStorage(newMetadata)
            return newMetadata
        }
    }

    static func updateMetadataInLocalStorage() {
        let metadata = loadMetadataFromLocalStorage() ?? Metadata()
        metadata.lastUpdated = Date.now
        saveMetadataToLocalStorage(metadata)
        Logger.log("Metadata updated at: \(metadata.lastUpdated)", self)
        RemoteMetadataManager.updateMetadataInFirebase()
    }

    static func saveMetadataToLocalStorage(_ metadata: Metadata) {
        do {
            let folderURL = try LocalStorageManager.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(metadataFileName)
            let data = try JSONEncoder().encode(metadata)
            try data.write(to: fileURL)
            Logger.log("Metadata saved at: \(fileURL.path)", self)
        } catch {
            Logger.log("Failed to save metadata: \(error)", self)
        }
    }

    static func loadMetadataFromLocalStorage() -> Metadata? {
        do {
            let folderURL = try LocalStorageManager.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(metadataFileName)
            let data = try Data(contentsOf: fileURL)
            let metadata = try JSONDecoder().decode(Metadata.self, from: data)
            return metadata
        } catch {
            Logger.log("Failed to load metadata: \(error)", self)
            return nil
        }
    }

    static func deleteMetadataFromLocalStorage() {
        do {
            let folderURL = try LocalStorageManager.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(metadataFileName)
            try fileManager.removeItem(at: fileURL)
            Logger.log("Metadata successfully deleted.", self)
        } catch {
            Logger.log("Error deleting metadata: \(error)", self)
        }
    }
}
