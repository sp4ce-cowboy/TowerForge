//
//  StorageHandler.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

class StorageHandler {
    static let folderName = Constants.LOCAL_STORAGE_CONTAINER_NAME
    static let fileName = Constants.LOCAL_STORAGE_FILE_NAME
    static let metadataName = Constants.METADATA_FILE_NAME

    var hello: Void

    var statisticsDatabase = StatisticsDatabase()
    var metadata = Metadata()

    init() {
        Self.initializeLocalStorageIfNotPresent()

        if let statistics = LocalStorage.loadDatabaseFromLocalStorage() {
            statisticsDatabase = statistics
        } else {
            statisticsDatabase.setToDefault()
        }

        if let metadata = LocalStorage.loadMetadataFromLocalStorage() {
            self.metadata = metadata
        } else {
            self.metadata = Metadata()
        }
    }

    deinit {
        save()
    }

    /// Initializes empty statistics and metadata if they don't already exist locally
    /// Called by the AppDelegate when the application is run.
    static func initializeLocalStorageIfNotPresent() {
        Logger.log("Initializing Metadata", Self.self)
        LocalStorage.initializeMetadataToLocalStorage()

        Logger.log("Initializing LocalStorage", Self.self)
        LocalStorage.initializeDatabaseToLocalStorage()
    }

    /// Saves the current statistics database to file
    func save() {
        Logger.log("SAVE: Saving Stats and Metadata to LocalStorage", Self.self)
        LocalStorage.saveDatabaseToLocalStorage(statisticsDatabase)
        metadata.update()
        LocalStorage.saveMetadataToLocalStorage(metadata)
    }

    func delete() {
        Logger.log("DELETE: Deleting Stats and Metadata to LocalStorage", Self.self)
        LocalStorage.deleteDatabaseFromLocalStorage()
        LocalStorage.deleteMetadataFromLocalStorage()
    }

}
