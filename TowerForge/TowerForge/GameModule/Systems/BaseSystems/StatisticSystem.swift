//
//  StatisticSystem.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

/// A system meant to handle the publication of Statistics updates
class StatisticSystem: TFSystem {
    var isActive = true
    
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager
    unowned var statsEngine: StatisticsEngine

    init(entityManager: EntityManager,
         eventManager: EventManager,
         statsEngine: StatisticsEngine) {
        self.entityManager = entityManager
        self.eventManager = eventManager
        self.statsEngine = statsEngine
    }
    
    func broadcast<T: TFEvent>(for event: T) {
        statsEngine.updateStatisticsOnReceive(event)
    }
    

}
