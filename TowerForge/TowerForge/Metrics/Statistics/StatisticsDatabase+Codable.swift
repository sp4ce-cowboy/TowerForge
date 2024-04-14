//
//  StatisticsDatabase+Codable.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

extension StatisticsDatabase: Codable {

    private static func generateStatisticsCollection(_ statsArray: [Statistic]) -> [StatisticTypeWrapper: Statistic] {
        var statisticsMap: [StatisticTypeWrapper: Statistic] = [:]

        for stat in statsArray {
            statisticsMap[stat.statisticName] = stat
        }

        return statisticsMap
    }

    func encode(to encoder: Encoder) throws {
        Logger.log("StatisticsDatabase encoder called")
        var container = encoder.container(keyedBy: StatisticsDatabaseCodingKeys.self)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .statistics)
        try statistics.values.forEach { try objectsContainer.encode($0) }
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StatisticsDatabaseCodingKeys.self)
        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: .statistics)
        var objects: [Statistic] = []

        while !objectsArrayForType.isAtEnd {
            let statObjectDict = try objectsArrayForType.nestedContainer(keyedBy: StatisticsDefaultCodingKeys.self)
            if let statObject = try Self.decodeObject(statObjectDict) {
                objects.append(statObject)
            }
        }

        Logger.log("Loaded Statistics Database with \(objects.count)")
        let statObjectsMap = Self.generateStatisticsCollection(objects)

        self.init(statObjectsMap)
    }

    private static func decodeObject(_ statObjectDict: KeyedDecodingContainer<StatisticsDefaultCodingKeys>)
    throws -> (any Statistic)? {

        let type = try statObjectDict.decode(StatisticTypeWrapper.self, forKey: .statisticName)
        let typeName = String(describing: type)
        let permanentValue = try statObjectDict.decode(Double.self, forKey: .permanentValue)
        let currentValue = try statObjectDict.decode(Double.self, forKey: .currentValue)

        guard let instance = StatisticsFactory.createInstance(of: typeName,
                                                              permanentValue: permanentValue,
                                                              currentValue: currentValue) else {

            throw DecodingError.dataCorruptedError(forKey: .statisticName,
                                                   in: statObjectDict,
                                                   debugDescription: "Cannot instantiate Statistic of type \(typeName)")
        }

        return instance
    }
}
