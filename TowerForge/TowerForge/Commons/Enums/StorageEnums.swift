//
//  StorageEnums.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

typealias TFStorageType = StorageEnums.StorageType
typealias TFAchievementType = StorageEnums.StorableAchievementNameType
class StorageEnums {

    /// An enum for the names of every Storable that can be stored.
    /// Adds an implicit "CheckRep", malicious actors cannot load
    /// random storables perhaps using obj-c's dynamic runtime.
    enum StorableNameType: String, CodingKey, Codable, CaseIterable {
        case dummyStorable // Temp dummy case to replace later
        case totalKillsAchievement
        case totalGamesAchievement
    }

    /// For achievements only.
    /// Rep-invariant: All cases must also be contained within StorableNameType
    enum StorableAchievementNameType: String, CodingKey, Codable, CaseIterable {
        case totalKillsAchievement
        case totalGamesAchievement
    }

    /// Used in the default implementation of Storage
    enum StorableDefaultCodingKeys: String, CodingKey {
        case storableId
        case storableName
        case storableValue
    }

    /// Used in StorageManager class
    enum StorageType: String, CodingKey, Codable {
        case achievementStorage
    }

    /// Used in Storage class
    enum StorageCodingKeys: String, CodingKey, Codable {
        case storageName
        case storedObjects
    }

    enum DatabaseCodingKeys: String, CodingKey, Codable {
        case storedData
    }

}
