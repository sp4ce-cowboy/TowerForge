//
//  StatisticsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class StatisticsFactory {
    public static let availableEventTypes: [TFEvent.Type] = [
        DamageEvent.self,
        MoveEvent.self,
        SpawnEvent.self,
        RemoveEvent.self,
        LifeEvent.self,
        KillEvent.self,
        DisabledEvent.self,
        RequestSpawnEvent.self,
        WaveSpawnEvent.self
    ]
    
    public static func getDefaultEmptyLinkDatabase() -> EventStatisticLinkDatabase {
        var eventStatLinkDatabase = EventStatisticLinkDatabase()
        availableEventTypes.forEach { eventStatLinkDatabase.registerEmptyEventType(for: $0) }
        return eventStatLinkDatabase
    }
}
