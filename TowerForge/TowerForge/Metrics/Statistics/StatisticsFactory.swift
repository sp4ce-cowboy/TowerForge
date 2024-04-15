//
//  StatisticsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class StatisticsFactory {

    static var eventStatisticLinks: [TFEventTypeWrapper: [StatisticTypeWrapper]] =
        [
            KillEvent.asType: [TotalKillsStatistic.asType],
            GameStartEvent.asType: [TotalGamesStatistic.asType],
            DeathEvent.asType: [TotalDeathsStatistic.asType]
        ]

    static var availableStatisticsTypes: [String: Statistic.Type] =
        [
            String(describing: TotalKillsStatistic.self): TotalKillsStatistic.self,
            String(describing: TotalGamesStatistic.self): TotalGamesStatistic.self,
            String(describing: TotalDeathsStatistic.self): TotalDeathsStatistic.self
        ]

    static var statisticDecoder: [String: (Decoder) throws -> Statistic] =
        [
            TotalKillsStatistic.asType.asString: { decoder in try TotalKillsStatistic(from: decoder) },
            TotalGamesStatistic.asType.asString: { decoder in try TotalGamesStatistic(from: decoder) },
            TotalDeathsStatistic.asType.asString: { decoder in try TotalDeathsStatistic(from: decoder) }
        ]

    static var defaultStatisticGenerator: [StatisticTypeWrapper: () -> Statistic] =
        [
            TotalKillsStatistic.asType: { TotalKillsStatistic() },
            TotalGamesStatistic.asType: { TotalGamesStatistic() },
            TotalDeathsStatistic.asType: { TotalDeathsStatistic() }
        ]

    static func registerStatisticType<T: Statistic>(_ stat: T) {
        availableStatisticsTypes[String(describing: T.self)] = T.self
        statisticDecoder[T.asType.asString] = { decoder in try T(from: decoder) }
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
