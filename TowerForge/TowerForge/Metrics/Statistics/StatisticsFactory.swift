//
//  StatisticsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class StatisticsFactory {

    static let availableStatisticsTypes: [String: Statistic.Type] =
        [
            String(describing: TotalKillsStatistic.self): TotalKillsStatistic.self,
            String(describing: TotalGamesStatistic.self): TotalGamesStatistic.self,
            String(describing: TotalDeathsStatistic.self): TotalDeathsStatistic.self
        ]

    static func getDefaultEventLinkDatabase() -> EventStatisticLinkDatabase {
        let eventStatLinkDatabase = EventStatisticLinkDatabase()
        ObjectSet.availableEventTypes.forEach { eventStatLinkDatabase.registerEmptyEventType(for: $0) }
        return eventStatLinkDatabase
    }

    static func getDefaultStatisticsDatabase() -> StatisticsDatabase {
        let statsDatabase = StatisticsDatabase()
        availableStatisticsTypes.values.forEach { statsDatabase.addStatistic(for: $0.asType) }
        return statsDatabase
    }

    static func createInstance(of typeName: String, permanentValue: Double, currentValue: Double) -> Statistic? {
        guard let type = availableStatisticsTypes[typeName] else {
            return nil
        }
        return type.init(permanentValue: permanentValue, currentValue: currentValue)
    }
}
