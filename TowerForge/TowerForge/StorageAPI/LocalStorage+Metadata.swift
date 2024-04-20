//
//  LocalStorage+Metadata.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

/// This extension adds utility methods specifically for local metadata operations
extension LocalStorage {
    static func initializeMetadataToLocalStorage() {
        if LocalStorage.loadMetadataFromLocalStorage() != nil {
            Logger.log("--- Metadata exists locally", Self.self)
        } else {
            let defaultMetadata = Metadata()
            Constants.CURRENT_PLAYER_ID = defaultMetadata.uniqueIdentifier
            Constants.CURRENT_DEVICE_ID = defaultMetadata.uniqueIdentifier

            LocalStorage.saveMetadataToLocalStorage(defaultMetadata)
            Logger.log("--- Created and saved a new empty metadata file.", Self.self)
            Logger.log("--- Current id: \(Constants.CURRENT_DEVICE_ID)", Self.self)
        }
    }

    static func saveMetadataToLocalStorage(_ metadata: Metadata) {
        do {
            let folderURL = try Self.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(metadataName)
            let data = try JSONEncoder().encode(metadata)
            try data.write(to: fileURL)
            Logger.log("Metadata saved at: \(fileURL.path)", self)
        } catch {
            Logger.log("Failed to save metadata: \(error)", self)
        }
    }

    static func loadMetadataFromLocalStorage() -> Metadata? {
        do {
            let folderURL = try Self.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(metadataName)
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
            let fileURL = folderURL.appendingPathComponent(metadataName)
            try FileManager.default.removeItem(at: fileURL)
            Logger.log("Metadata successfully deleted.", self)
        } catch {
            Logger.log("Error deleting metadata: \(error)", self)
        }
        
        Logger.log("Metadata successfully deleted.", self)
    }
}
