//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storage Architecture of TowerForge consists of a few layers. From highest
/// to lowest, these are:
/// - StorageManager: Application wide access to data persistence
/// - Database: A data structure that underlies storage manager, essentially a collection of Storages
/// - Storage: A collection of a specific type of items that can be written to data
/// - Storable: The lowest level of, represents a single unit of an item that can be stored.
///
/// This allows for a nuanced, sequential and hierarchial approach to data persistence,
/// within a monolithic Storage Architecture, and thus, without having to fragment
/// Storage across TowerForge.
///
/// Hypothetical Example: local copy of the TowerForge application may contain information
/// such as a list of Achievements and a list of user preferences. This would translate
/// to a "AchievementStorage: Storage" class and "UserPrefStorage: Storage" class being
/// stored within the StorageManager and loaded upon every launch of the application.
/// "Achievement: Storable" would be stored inside AchievementStorage and "UserPreferenece: Storable"
/// would be stored within the UserPrefStorage.
///
/// A singular, universal StorageManager that allows for simultaneously storing and isolating
/// storable items of different types.
class StorageManager: Codable {
    static let folderName = Constants.STORAGE_CONTAINER_NAME
    static let shared = StorageManager() // Singleton instance
    var storedData = Database()

    static func fileURL(for directory: FileManager.SearchPathDirectory, withName name: String) throws -> URL {
        let fileManager = FileManager.default

        return try fileManager.url(for: directory, in: .userDomainMask,
                                   appropriateFor: nil, create: true).appendingPathComponent(name)
    }

    static func createFolderIfNeeded(folderName: String) throws -> URL {
        let fileManager = FileManager.default
        let documentsURL: URL = try fileManager.url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: false)

        let folderURL = documentsURL.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL,
                                            withIntermediateDirectories: true, attributes: nil)
        }

        return folderURL
    }

    /// Lists all saved files as file name String.
    static func listSavedFiles(folderName: String = folderName) -> [String] {
        do {
            let folderURL = try createFolderIfNeeded(folderName: folderName)
            let contents = try FileManager.default.contentsOfDirectory(at: folderURL,
                                                                       includingPropertiesForKeys: nil)

            let files = contents
                .filter { $0.pathExtension == "json" }
                .map { $0.lastPathComponent }

            return files

        } catch {
            Logger.log("Error listing files: \(error)")
            return []
        }
    }

    /// Deletes all stored files
    static func deleteAllFiles(_ fileList: [String], _ folder: String = Constants.STORAGE_CONTAINER_NAME) {
        for fileName in fileList {
            do {
                let folderURL = try createFolderIfNeeded(folderName: folder)
                let fileURL = folderURL.appendingPathComponent(fileName)
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                Logger.log("Error deleting file: \(fileName), \(error)")
            }
        }

        Logger.log("All files deleted.")
    }

    static func saveDatabase(_ database: Database,
                             withName name: String = UUID().uuidString,
                             folderName: String = folderName) {
        guard !name.isEmpty else {
            return
        }
        let fileName = name + ".json"

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(database)
            let folderURL = try StorageManager.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(fileName)

            try data.write(to: fileURL)
            Logger.log("Saved Storage at: \(fileURL.path)")
        } catch {
            Logger.log("Error saving Database: \(error)")
        }
    }

    static func loadDatabase(from fileName: String, folderName: String = folderName) -> Database? {
        do {
            let folderURL = try StorageManager.createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(fileName)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(Database.self, from: data)
        } catch {
            Logger.log("Error loading Storage: \(error)")
            return nil
        }
    }
}
