//
//  StorageHandler.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

class StorageHandler: AuthenticationDelegate {

    static let folderName = Constants.LOCAL_STORAGE_CONTAINER_NAME
    static let fileName = Constants.LOCAL_STORAGE_FILE_NAME
    static let metadataName = Constants.METADATA_FILE_NAME

    static var currentPlayerId: String { Constants.CURRENT_PLAYER_ID }
    static var currentDeviceId: String { Constants.CURRENT_DEVICE_ID }

    private let authenticationProvider = AuthenticationProvider()
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

    /// Universal save
    func save() {
        Logger.log("SAVE: Saving Stats and Metadata to LocalStorage", Self.self)
        LocalStorage.saveDatabaseToLocalStorage(statisticsDatabase)
        metadata.updateTimeToNow()
        LocalStorage.saveMetadataToLocalStorage(metadata)
    }

    /// Universal delete
    func delete() {
        Logger.log("DELETE: Deleting Stats and Metadata to LocalStorage", Self.self)
        LocalStorage.deleteDatabaseFromLocalStorage()
        LocalStorage.deleteMetadataFromLocalStorage()
    }

    func onLogin() {
        Task {
            await onAsyncLogin()
        }
    }

    func onAsyncLogin() async {
        Logger.log("IMPT: onLogin IS CALLED FROM STORAGE_HANDLER", Self.self)

        guard let userId = authenticationProvider.getCurrentUserId() else {
            Logger.log("IMPT: onLogin failed due to userId nil from STORAGE_HANDLER", Self.self)
            return
        }

        /// Update the playerId and metadata locally
        self.localUpdatePlayerIdAndMetadata(with: userId)
        if await checkIfRemotePlayerDataExists() {
            await self.onReLogin()
        } else {
            self.onFirstLogin()
        }

        // if they don't, execute onFirstLogin

        // if they do, execute onReLogin
    }

    func localUpdatePlayerIdAndMetadata(with userId: String) {
        Constants.CURRENT_PLAYER_ID = userId
        metadata.updateIdentifierToCurrentID()
        self.save()
    }

    /// Returns true only if both Metadata and Storage exist
    func checkIfRemotePlayerDataExists() async -> Bool {
        let storageExists = RemoteStorage.checkIfPlayerStorageExists(for: Self.currentPlayerId)
        let metadataExists = await RemoteStorage.checkIfPlayerMetadataExistsAsync(for: Self.currentPlayerId)

        if (storageExists && !metadataExists) || (!storageExists && metadataExists) {
            Logger.log("Inconsisteny error: Storage Exists: \(storageExists), Metadata Exists: \(metadataExists)")
        }

        return storageExists && metadataExists
    }

    func onLogout() {
        Logger.log("IMPT: onLOGOUT IS CALLED FROM STORAGE_HANDLER", Self.self)
        self.save() // Save any potential unsaved changes
        metadata.resetIdentifier() // Reset metadata to original value
        Logger.log("--- metadata reset to \(metadata.uniqueIdentifier)", Self.self)
        self.save() // Save updated metadata
    }

    /// Returns true if re-login success, false otherwise
    func onReLogin() async -> Bool {
        // Fetch metadata
        guard let remoteMetadata = await RemoteStorage.loadMetadataFromFirebase(player: Self.currentPlayerId) else {
            Logger.log("RELOGIN ERROR: REMOTE METADATA NOT FOUND")
            return false
        }

        // Fetch storage
        guard let remoteStorage = RemoteStorage.loadStorageFromFirebase(player: Self.currentPlayerId) else {
            Logger.log("RELOGIN ERROR: REMOTE STORAGE NOT FOUND")
            return false
        }

        var finalStorage = StatisticsDatabase.merge(this: remoteStorage, that: statisticsDatabase)

        // Merge storage - MERGE
        // Merge metadata - KEEP LATEST
        // Set storage to merged storage
        // Save new storage to file
        // Universal save will automatically update metadata
        // Universal save to remote

        return true

    }

    func onFirstLogin() {
        RemoteStorage.saveStorageToFirebase(player: Self.currentPlayerId,
                                            with: statisticsDatabase)

        RemoteStorage.saveMetadataToFirebase(player: Self.currentPlayerId,
                                             with: metadata)
    }

}
