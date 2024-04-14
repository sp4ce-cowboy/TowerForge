//
//  StorageEnums.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

typealias TFAchievementType = StorageEnums.StorableAchievementNameType
typealias StatisticsDatabaseCodingKeys = StorageEnums.StatisticsDatabaseCodingKeys
typealias StatisticsDefaultCodingKeys = StorageEnums.StatisticsDefaultCodingKeys
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
    enum StatisticsDatabaseCodingKeys: String, CodingKey, Codable {
        case statistics
    }

    enum StatisticsDefaultCodingKeys: String, CodingKey, Codable {
        case statisticName
        case permanentValue
        case currentValue
    }
}
