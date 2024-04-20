//
//  LocalStorage.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

/// Utility class to provide static methods for local storage operations
class LocalStorage {
    static let folderName = Constants.LOCAL_STORAGE_CONTAINER_NAME
    static let fileName = Constants.LOCAL_STORAGE_FILE_NAME
    static let metadataName = Constants.METADATA_FILE_NAME

    private init() { }

    static func initializeDatabaseToLocalStorage() {
        /// Initialize StatisticsDatabase
        if Self.loadDatabaseFromLocalStorage() != nil {
            Logger.log("--- Database exists locally", Self.self)
        } else {
            let defaultDatabase = StatisticsFactory.getDefaultStatisticsDatabase()
            Self.saveDatabaseToLocalStorage(defaultDatabase)
            Logger.log("--- Created and saved a new empty database.", Self.self)
        }
    }

    /// Saves the input statistics database to file
    static func saveDatabaseToLocalStorage(_ stats: StatisticsDatabase) {
        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(stats)
            let folderURL = try Self.createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.fileName)
            try data.write(to: fileURL)
            Logger.log("Saved Statistics Database at: \(fileURL.path)", self)
        } catch {
            Logger.log("Error saving statistics Database: \(error)", self)
        }
    }

    /// Returns the StatisticsDatabase if it exists at the specific location or nil otherwise.
    static func loadDatabaseFromLocalStorage() -> StatisticsDatabase? {
        do {
            let folderURL = try Self.createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.fileName)
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(StatisticsDatabase.self, from: data)
        } catch {
            Logger.log("Error loading statistics: \(error)", self)
            return nil
        }
    }

    /// Deletes the stored statistics database from file
    static func deleteDatabaseFromLocalStorage() {
        do {
            let folderURL = try Self.createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.fileName)
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            Logger.log("Error deleting file: \(Self.fileName), \(error)", self)
        }
        Logger.log("Database successfully deleted.", self)
    }

    /// Helper function to construct a FileURL
    static func fileURL(for directory: FileManager.SearchPathDirectory, withName name: String) throws -> URL {
        let fileManager = FileManager.default

        return try fileManager.url(for: directory,
                                   in: .userDomainMask,
                                   appropriateFor: nil,
                                   create: true).appendingPathComponent(name)
    }

    /// Helper function to create a folder using the shared FileManager for a given folderName
    static func createFolderIfNeeded(folderName: String) throws -> URL {
        let fileManager = FileManager.default
        let documentsURL: URL = try fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)

        let folderURL = documentsURL.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: folderURL.path) {
            try fileManager.createDirectory(at: folderURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        }
        return folderURL
    }
}
