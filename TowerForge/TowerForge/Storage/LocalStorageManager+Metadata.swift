//
//  LocalStorageManager+Metadata.swift
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
extension LocalStorageManager {

    static func saveMetadataToLocalStorage() {
        let metadata = Metadata(lastUpdated: Date())
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            let folderURL = try createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.metadataName)
            let data = try encoder.encode(metadata)
            try data.write(to: fileURL)
            Logger.log("Saved metadata at: \(fileURL.path)", self)
        } catch {
            Logger.log("Error saving metadata: \(error)", self)
        }
    }

    static func loadMetadataFromLocalStorage() -> Metadata? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let folderURL = try createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.metadataName)
            let data = try Data(contentsOf: fileURL)
            let metadata = try decoder.decode(Metadata.self, from: data)
            return metadata
        } catch {
            Logger.log("Error loading metadata: \(error)", self)
            return nil
        }
    }

    /// Deletes the stored metadata from file    
    static func deleteMetadataFromLocalStorage() {
        do {
            let folderURL = try createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.metadataName)
            try FileManager.default.removeItem(at: fileURL)
            Logger.log("Deleted metadata at: \(fileURL.path)", self)
        } catch {
            Logger.log("Error deleting metadata: \(error)", self)
        }
    }

    /// Retrieves file metadata provided by iOS for a given filename in the document directory.
    static func getFileManagerMetadata(for filename: String) -> [FileAttributeKey: Any]? {
        do {
            let folderURL = try createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(filename)
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            return attributes
        } catch {
            Logger.log("Error retrieving file metadata: \(error)", self)
            return nil
        }
    }
}
