//
//  AiSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import SpriteKit

class AiSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager
    var aiPlayers: [Player] = []

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        var aiComponents: [Player: AiComponent] = [:]
        for aiComponent in entityManager.components(ofType: AiComponent.self) {
            guard let player = aiComponent.entity?.component(ofType: PlayerComponent.self)?.player else {
                continue
            }
            aiComponents[player] = aiComponent
            aiComponent.update(deltaTime: time)
        }

        var event: TFEvent?

        for aiPlayer in aiPlayers {
            guard let aiComponent = aiComponents[aiPlayer], aiComponent.spawn(),
                  let unitType = aiComponent.chosenUnit else {
                continue
            }

            let newEvent = RequestSpawnEvent(ofType: unitType, timestamp: CACurrentMediaTime(),
                                             position: aiComponent.spawnLocation, player: aiPlayer)

            guard var event = event else {
                event = newEvent
                continue
            }
            event = event.concurrentlyWith(newEvent)
        }

        guard let event = event else {
            return
        }
        eventManager.add(event)
    }
}
