//
//  StorageHandler.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

protocol StatisticsEngineDelegate: AnyObject {
    var statisticsDatabase: StatisticsDatabase { get set }
    func save()
    func localSave()
}

class StorageHandler: AuthenticationDelegate, StatisticsEngineDelegate {

    static let folderName = Constants.LOCAL_STORAGE_CONTAINER_NAME
    static let fileName = Constants.LOCAL_STORAGE_FILE_NAME
    static let metadataName = Constants.METADATA_FILE_NAME

    static var isLoggedIn = false
    static var CONFLICT_RESOLUTION: StorageConflictResolution { Constants.CONFLICT_RESOLTION }
    static var currentPlayerId: String { Constants.CURRENT_PLAYER_ID }
    static var currentDeviceId: String { Constants.CURRENT_DEVICE_ID }

    let authenticationProvider = AuthenticationProvider()
    var statisticsDatabase = StatisticsDatabase()
    var metadata = Metadata()

    init() {
        Self.initializeLocalStorageIfNotPresent()
        authenticationProvider.addObserver(self)

        // Set statistic DB to default if it doesn't exist
        if let statistics = LocalStorage.loadDatabaseFromLocalStorage() {
            statisticsDatabase = statistics
        } else {
            statisticsDatabase = StatisticsFactory.getDefaultStatisticsDatabase()
        }

        // Set metadata to default if it doesn't exists
        if let metadata = LocalStorage.loadMetadataFromLocalStorage() {
            self.metadata = metadata
        } else {
            self.metadata = Metadata()
        }
    }

    deinit {
        Logger.log("StorageHandler: Deinit is called", self)
    }

    /// Initializes empty statistics and metadata if they don't already exist locally
    /// Called by the AppDelegate when the application is run.
    static func initializeLocalStorageIfNotPresent() {
        Logger.log("Initializing Metadata", Self.self)
        LocalStorage.initializeMetadataToLocalStorage()

        Logger.log("Initializing LocalStorage", Self.self)
        LocalStorage.initializeDatabaseToLocalStorage()
    }

    /// Universal save
    func save() {
        Logger.log("U-SAVE: Saving Stats and Metadata Universally for \(Self.currentPlayerId)", Self.self)
        self.localSave()
        self.remoteSave()
    }

    func localSave() {
        Logger.log("L-SAVE: Saving Stats and Metadata to LocalStorage", Self.self)
        LocalStorage.saveDatabaseToLocalStorage(self.statisticsDatabase)
        metadata.updateTimeToNow()
        LocalStorage.saveMetadataToLocalStorage(self.metadata)
    }

    func remoteSave() {
        Logger.log("R-SAVE: Saving Stats and Metadata to RemoteData for \(Self.currentPlayerId)", Self.self)
        RemoteStorage.saveDatabaseToFirebase(player: Self.currentPlayerId, with: self.statisticsDatabase) {
            if $0 {
                Logger.log("R-SAVE-DB SUCCESS", self)
            } else {
                Logger.log("R-SAVE-DB FAILURE", self)
            }
        }

        metadata.updateTimeToNow()
        RemoteStorage.saveMetadataToFirebase(player: Self.currentPlayerId, with: self.metadata) {
            if $0 {
                Logger.log("R-SAVE-MD SUCCESS", self)
            } else {
                Logger.log("R-SAVE-MD FAILURE", self)
            }
        }
    }

    /// Universal delete
    func delete() {
        Logger.log("U-DELETE: Deleting Stats and Metadata Universally", Self.self)
        self.statisticsDatabase.setToDefault()
        self.metadata = Metadata()
        self.localDelete()
        self.remoteDelete()
    }

    func localDelete() {
        Logger.log("L-DELETE: Deleting Stats and Metadata from LocalStorage", Self.self)
        LocalStorage.deleteDatabaseFromLocalStorage()
        LocalStorage.deleteMetadataFromLocalStorage()
    }

    func remoteDelete() {
        Logger.log("R-DELETE: Deleting Stats and Metadata from LocalStorage", Self.self)
        RemoteStorage.deleteDatabaseFromFirebase(player: Self.currentPlayerId)
        RemoteStorage.deleteMetadataFromFirebase(player: Self.currentPlayerId)
    }

}
