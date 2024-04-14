//
//  LocalStorageManager.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// A utility class to provide standard storage operations and interaction with
/// the on-device files storage system via the FileManager API.
///
/// Currently the Storage means is limited to storing Statistics only, possible
/// expansion to a generic type can be considered.
class LocalStorageManager {
    static let folderName = Constants.LOCAL_STORAGE_CONTAINER_NAME
    static let fileName = Constants.LOCAL_STORAGE_FILE_NAME
    static let metadataName = Constants.METADATA_NAME

    /// Creates an empty local file to store the database if one doesn't already exist.
    /// Called by the AppDelegate when the application is run.
    static func initializeLocalStatisticsDatabase() {
        if Self.loadDatabaseFromLocalStorage() != nil {
            Logger.log("Loaded existing database.", Self.self)
        } else {
            Self.saveDatabaseToLocalStorage(StatisticsFactory.getDefaultStatisticsDatabase())
            Logger.log("Created and saved a new empty database.", Self.self)
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

    /// Loads a database (with the class constant folderName and fileName) from file
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

    /// Deletes the stored database from file
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

    static func saveMetadataToLocalStorage() {
        let dateFormatter = ISO8601DateFormatter()
        let currentTimeString = dateFormatter.string(from: Date())

        do {
            let folderURL = try createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(metadataName)
            try currentTimeString.write(to: fileURL, atomically: true, encoding: .utf8)
            Logger.log("Saved metadata at: \(fileURL.path)", self)
        } catch {
            Logger.log("Error saving metadata: \(error)", self)
        }
    }

    static func loadMetadataFromLocalStorage() -> Date? {
        do {
            let folderURL = try createFolderIfNeeded(folderName: folderName)
            let fileURL = folderURL.appendingPathComponent(metadataName)
            let dateString = try String(contentsOf: fileURL, encoding: .utf8)
            let dateFormatter = ISO8601DateFormatter()
            return dateFormatter.date(from: dateString)
        } catch {
            Logger.log("Error loading metadata: \(error)", self)
            return nil
        }
    }

    /// Deletes the stored database from file
    static func deleteMetadataFromLocalStorage() {
        do {
            let folderURL = try Self.createFolderIfNeeded(folderName: Self.folderName)
            let fileURL = folderURL.appendingPathComponent(Self.fileName)
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            Logger.log("Error deleting file: \(Self.fileName), \(error)", self)
        }
        Logger.log("Database successfully deleted.", self)
    }

    /// Retrieves file metadata provided by iOS for a given filename in the document directory.
    static func getFileMetadata(for filename: String) -> [FileAttributeKey: Any]? {
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

    /// Helper function to construct a FileURL
    static func fileURL(for directory: FileManager.SearchPathDirectory, withName name: String) throws -> URL {
        let fileManager = FileManager.default

        return try fileManager.url(for: directory, in: .userDomainMask,
                                   appropriateFor: nil, create: true).appendingPathComponent(name)
    }

    /// Helper function to create a folder using the shared FileManager for a given folderName
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

    static func compareTimes(_ time1: Date, _ time2: Date) -> Bool {
        time1 > time2
    }

}
