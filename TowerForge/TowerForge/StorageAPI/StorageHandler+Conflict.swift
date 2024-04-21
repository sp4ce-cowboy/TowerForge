//
//  StorageHandler+Conflict.swift
//  TowerForge
//
//  Created by Rubesh on 21/4/24.
//

import Foundation

/// This extension adds conflict resolution methods to StorageHandler
extension StorageHandler {

    /// Returns the StatisticsDatabase from the location that corresponds to the most recent save.
    static func getLocationWithLatestMetadata(completion: @escaping (StorageLocation?) -> Void) {
        RemoteStorage.loadMetadataFromFirebase(player: Self.currentPlayerId) { remoteMetadata, remoteError in
            let localMetadata = LocalStorage.loadMetadataFromLocalStorage()

            // Handle errors or nil cases
            if let remoteError = remoteError {
                Logger.log("Error occurred retrieving metadata: \(remoteError)", self)
            }

            switch (remoteMetadata, localMetadata) {
            case (_?, nil):
                completion(.Remote)
            case (nil, _?):
                completion(.Local)
            case (let remote?, let local?):
                completion(remote > local ? .Remote : .Local)
            default:
                completion(nil)
            }
        }
    }

    static func loadLatest(completion: @escaping (StatisticsDatabase?) -> Void) {
        Self.getLocationWithLatestMetadata { location in
            switch location {

            case .Local:
                if let stats = LocalStorage.loadDatabaseFromLocalStorage() {
                    completion(stats)
                } else {
                    Logger.log("Error: Failed to load local database.", self)
                    completion(nil)
                }

            case .Remote:
                RemoteStorage.loadDatabaseFromFirebase(player: Self.currentPlayerId) { statsData, error in
                    if let error = error {
                        Logger.log("Error occurred loading from database: \(error)", self)
                        completion(nil)
                    } else {
                        completion(statsData)
                    }
                }

            default:
                Logger.log("No valid metadata found, cannot determine latest storage.", self)
                completion(nil)
            }
        }
    }

    static func resolveConflict(this: StatisticsDatabase,
                                that: StatisticsDatabase,
                                completion: @escaping (StatisticsDatabase?) -> Void) {

        switch CONFLICT_RESOLUTION {
        case .MERGE:
            Logger.log("RESOLVE --- THIS DB is \(String(describing: this.toString()))", self)
            Logger.log("RESOLVE --- THAT DB is \(String(describing: that.toString()))", self)
            completion(StatisticsDatabase.merge(this: this, that: that))
            return
        case .KEEP_LATEST_ONLY:
            Self.loadLatest { completion($0) }
            return
        case .PRESERVE_LOCAL:
            completion(this)
            return
        }
    }

}
