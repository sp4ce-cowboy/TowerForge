//
//  TimerSystem.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class TimerSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        for timerComponent in entityManager.components(ofType: TimerComponent.self) {
            timerComponent.update(deltaTime: time)
        }
    }
}
