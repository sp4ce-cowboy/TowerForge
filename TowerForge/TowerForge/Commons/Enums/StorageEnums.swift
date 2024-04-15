//
//  StorageEnums.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

typealias StatisticsDatabaseCodingKeys = StorageEnums.StatisticsDatabaseCodingKeys
typealias StatisticCodingKeys = StorageEnums.StatisticsDefaultCodingKeys
typealias DynamicCodingKeys = StorageEnums.DynamicCodingKeys
typealias StorageLocation = StorageEnums.StorageLocation
typealias StorageConflictResolution = StorageEnums.StorageConflictResolution

class StorageEnums {

    enum StatisticsDatabaseCodingKeys: String, CodingKey, Codable {
        case statistics
    }

    enum StatisticsDefaultCodingKeys: String, CodingKey, Codable {
        case statisticName
        case permanentValue
        case currentValue
    }

    enum StorageLocation: String, Codable {
        case Local
        case Remote
    }

    enum StorageConflictResolution: String {
        case MERGE
        case KEEP_LATEST_ONLY
    }

    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
}
