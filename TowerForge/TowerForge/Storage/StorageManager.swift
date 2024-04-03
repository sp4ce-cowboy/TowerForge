//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storage Architecture of TowerForge consists of a few layers. From highest
/// to lowest, these are:
/// - StorageManager: Interface that allows application wide access to data persistence
/// - Database: A data structure that underlies storage manager, essentially a collection of Storages
/// - Storage: A collection of a specific type of items that can be written to file
/// - Storable: The lowest level of storage, represents a single unit of an item that can be written to file
///
/// This allows for a nuanced, sequential and hierarchial approach to data persistence,
/// within a monolithic Storage Architecture, and thus, without having to fragment
/// Storage across TowerForge. This also allows for Storage Manager to transform into an adaptor
/// if the need arises to replace FileManager with some other form of persistence, like CloudKit or
/// Firebase or something else.
///
/// Hypothetical Example: local copy of the TowerForge application may contain information
/// such as a list of Achievements and a list of user preferences. This would translate
/// to a "AchievementStorage: Storage" class and "UserPrefStorage: Storage" class being
/// stored within Database inside the StorageManager and loaded upon every launch of the application.
/// "Achievement: Storable" would be stored inside AchievementStorage and "UserPreferenece: Storable"
/// would be stored within the UserPrefStorage.
///
/// A singular, universal StorageManager that allows for simultaneously storing and isolating
/// storable items of different types.
class StorageManager {
    static let folderName = Constants.STORAGE_CONTAINER_NAME
    static let fileName = Constants.TF_DATABASE_NAME

    internal static let shared = StorageManager() // Singleton instance (might need to consider)
    internal var storedDatabase: LocalDatabase

    init(storedData: LocalDatabase = LocalDatabase()) {
        self.storedDatabase = storedData
    }

    /// Creates an empty local file to store the database if one doesn't already exist.
    /// Called by the AppDelegate when the application is run.
    static func initializeData() {
        if let loadedDatabase = StorageManager.shared.loadFromFile() {
            StorageManager.shared.storedDatabase = loadedDatabase
            Logger.log("Loaded existing database.", Self.self)
        } else {
            StorageManager.shared.storedDatabase = LocalDatabase() // Create empty database
            StorageManager.shared.saveToFile() // Save the new empty database
            Logger.log("Created and saved a new empty database.", Self.self)
        }

        StorageManager.shared.initializeDefaultAchievements()
    }

    /// Saves the current Database to file
    func saveToFile() {
        let fileNameCombined = Self.fileName + ".json"
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(storedDatabase)
            let folderURL = try Self.createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(fileNameCombined)
            try data.write(to: fileURL)
            Logger.log("Saved Storage at: \(fileURL.path)")
        } catch {
            Logger.log("Error saving Database: \(error)")
        }
    }

    /// Loads a database (with the class constant folderName and fileName) from file
    func loadFromFile() -> LocalDatabase? {
        do {
            let folderURL = try Self.createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.fileName)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(LocalDatabase.self, from: data)
        } catch {
            Logger.log("Error loading Storage: \(error)")
            return nil
        }
    }

    /// Deletes the stored Database from file
    func deleteDatabaseFromFile() {
        do {
            let folderURL = try Self.createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.fileName)
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            Logger.log("Error deleting file: \(Self.fileName), \(error)")
        }
        Logger.log("Database successfully deleted.")
    }

    /// Helper function to construct a FileURL
    static func fileURL(for directory: FileManager.SearchPathDirectory, withName name: String) throws -> URL {
        let fileManager = FileManager.default

        return try fileManager.url(for: directory, in: .userDomainMask,
                                   appropriateFor: nil, create: true).appendingPathComponent(name)
    }

    /// Helper function to create a folder for a given
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
}
