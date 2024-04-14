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
class StorageEnums {

    enum StatisticsDatabaseCodingKeys: String, CodingKey, Codable {
        case statistics
    }

    enum StatisticsDefaultCodingKeys: String, CodingKey, Codable {
        case statisticName
        case permanentValue
        case currentValue
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
