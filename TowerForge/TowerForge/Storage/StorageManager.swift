//
//  StorageManager.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// The class responsible for providing application wide Storage access and
/// synchronizing between Local Storage and Remote Storage. The application interacts only
/// with StorageManager which handles all storage operations.
class StorageManager {
    static var defaultErrorClosure: (Error?) -> Void = { error in
        if let error = error {
            Logger.log("Generic error message invoked: \(error)")
        } else {
            Logger.log("Generic success message invoked.")
        }
    }

    static func onLogin(with userId: String) {
        var localStorage = LocalStorageManager.loadDatabaseFromLocalStorage()

        if let localStorage = localStorage {
            _ = Self.saveUniversally(localStorage)
        } else {
            var defaultStorage = StatisticsFactory.getDefaultStatisticsDatabase()
            _ = Self.saveUniversally(defaultStorage)
            localStorage = defaultStorage
        }

        Constants.CURRENT_PLAYER_ID = userId
        var remoteStorage = StatisticsDatabase()

        RemoteStorageManager.loadDatabaseFromFirebase { statisticsDatabase, error in
            if let error = error {
                Logger.log("Error loading data: \(error)", self)
            } else if let statisticsDatabase = statisticsDatabase {
                Logger.log("Successfully loaded statistics database.", self)
                remoteStorage = statisticsDatabase
            } else {
                // No error and no database implies that database is empty, thus initialize new one
                Logger.log("No error and empty database, new one will be created", self)
                remoteStorage = StatisticsFactory.getDefaultStatisticsDatabase()
            }
        }

        var finalStorage = StatisticsDatabase.merge(this: localStorage, that: remoteStorage)

        if let finalStorage = finalStorage {
            _ = Self.saveUniversally(finalStorage)
        }

    }

    static func onLogout() {
        Constants.CURRENT_PLAYER_ID = Constants.CURRENT_DEVICE_ID
    }

    static func resetAllStorage() {
        Self.deleteAllRemoteStorage()
        Self.deleteAllLocalStorage()
    }

    static func deleteAllLocalStorage() {
        LocalStorageManager.deleteDatabaseFromLocalStorage()
        LocalMetadataManager.deleteMetadataFromLocalStorage()
    }

    static func deleteAllRemoteStorage() {
        RemoteStorageManager.deleteDatabaseFromFirebase { error in
            if let error = error {
                Logger.log("Deletion of all remote storage failed by StorageManager: \(error)", self)
            } else {
                Logger.log("Delete of all remote storage success", self)
            }
        }
    }

    static func saveUniversally(_ statistics: StatisticsDatabase) -> StatisticsDatabase? {
        LocalStorageManager.saveDatabaseToLocalStorage(statistics)
        return Self.pushToRemote()

    }

    static func loadUniversally() -> StatisticsDatabase? {
        if let stats = LocalStorageManager.loadDatabaseFromLocalStorage() {
            return stats
        } else {
            let localStorage = StatisticsFactory.getDefaultStatisticsDatabase()
            return saveUniversally(localStorage)
        }
    }

    /// Pushes local data to remote
    /// - Firstly loads data from local storage (or creates empty storage if it doesn't exist)
    /// - Then loads data from remote storage (or creates empty storage if it doesn't exist)
    /// - Compares both data, merges them, and pushes back to remote.
    ///
    /// This ensures that no information is overwritten in the process.
    private static func pushToRemote() -> StatisticsDatabase? {
        // Explicitly load storage to ensure that uploaded data is
        var localStorage: StatisticsDatabase
        var remoteStorage = StatisticsDatabase()

        if let localStats = LocalStorageManager.loadDatabaseFromLocalStorage() {
            localStorage = localStats
        } else {
            LocalStorageManager.initializeLocalStatisticsDatabase()
            localStorage = StatisticsFactory.getDefaultStatisticsDatabase()
        }

        RemoteStorageManager.loadDatabaseFromFirebase { statisticsDatabase, error in
            if let error = error {
                Logger.log("Error loading data: \(error)", self)
            } else if let statisticsDatabase = statisticsDatabase {
                Logger.log("Successfully loaded statistics database.", self)
                remoteStorage = statisticsDatabase
            } else {
                // No error and no database implies that database is empty, thus initialize new one
                Logger.log("No error and empty database, new one will be created", self)
                remoteStorage = StatisticsFactory.getDefaultStatisticsDatabase()
            }
        }

        guard let finalStorage = StatisticsDatabase.merge(this: localStorage, that: remoteStorage) else {
            return nil
        }

        RemoteStorageManager.saveDatabaseToFirebase(finalStorage) { error in
            if let error = error {
                Logger.log("Saving to firebase error: \(error)", self)
            } else {
                Logger.log("Saving to firebase success", self)
            }
        }

        LocalStorageManager.saveDatabaseToLocalStorage(finalStorage)
        return finalStorage
    }

}
