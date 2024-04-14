//
//  StatisticsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class StatisticsFactory {

    static var availableStatisticsTypes: [String: Statistic.Type] =
        [
            String(describing: TotalKillsStatistic.self): TotalKillsStatistic.self,
            String(describing: TotalGamesStatistic.self): TotalGamesStatistic.self,
            String(describing: TotalDeathsStatistic.self): TotalDeathsStatistic.self
        ]

    static var defaultStatisticDecoder: [StatisticTypeWrapper: (JSONDecoder, Data) throws -> Statistic] =
        [
            TotalKillsStatistic.asType: { decoder, data in try decoder.decode(TotalKillsStatistic.self, from: data) },
            TotalGamesStatistic.asType: { decoder, data in try decoder.decode(TotalGamesStatistic.self, from: data) },
            TotalDeathsStatistic.asType: { decoder, data in try decoder.decode(TotalDeathsStatistic.self, from: data) }
        ]

    static var defaultStatisticGenerator: [StatisticTypeWrapper: () -> Statistic] =
        [
            TotalKillsStatistic.asType: { TotalKillsStatistic() },
            TotalGamesStatistic.asType: { TotalGamesStatistic() },
            TotalDeathsStatistic.asType: { TotalDeathsStatistic() }
        ]

    static func registerStatisticType<T: Statistic>(_ stat: T) {
        availableStatisticsTypes[String(describing: T.self)] = T.self
        defaultStatisticDecoder[T.asType] = { decoder, data in try decoder.decode(T.self, from: data) }
        defaultStatisticGenerator[T.asType] = { T() }
    }

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
