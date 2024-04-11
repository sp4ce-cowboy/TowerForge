//
//  StatisticsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class StatisticsFactory {
    static let availableEventTypes: [TFEvent.Type] = [
        DamageEvent.self,
        MoveEvent.self,
        SpawnEvent.self,
        RemoveEvent.self,
        LifeEvent.self,
        KillEvent.self,
        DisabledEvent.self,
        RequestSpawnEvent.self,
        WaveSpawnEvent.self,
        GameStartEvent.self,
        DeathEvent.self
    ]

    static let availableStatisticsTypes: [Statistic.Type] = [
        TotalKillsStatistic.self,
        TotalGamesStatistic.self,
        TotalDeathsStatistic.self
    ]

    static func getDefaultEventLinkDatabase() -> EventStatisticLinkDatabase {
        let eventStatLinkDatabase = EventStatisticLinkDatabase()
        availableEventTypes.forEach { eventStatLinkDatabase.registerEmptyEventType(for: $0) }
        return eventStatLinkDatabase
    }

    static func getDefaultStatisticsDatabase() -> StatisticsDatabase {
        let statsDatabase = StatisticsDatabase()
        StatisticName.allCases.forEach { statsDatabase.addStatistic(for: $0) }
        return statsDatabase
    }
}
