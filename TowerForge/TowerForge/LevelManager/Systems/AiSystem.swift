//
//  AiSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import Foundation

class AiSystem: TFSystem {
    var isActive = true
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        guard let entityManager = entityManager, let eventManager = eventManager else {
            return
        }

        let aiComponents = entityManager.components(ofType: AiComponent.self)
        for aiComponent in aiComponents {
            guard let event = aiComponent.spawn() else {
                continue
            }
            eventManager.add(event)
        }
    }
}
