//
//  PositionSystem.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation
import UIKit
import QuartzCore

class PositionSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        let positionComponents = entityManager.components(ofType: PositionComponent.self)
        for positionComponent in positionComponents where positionComponent.outOfBound() {
            print(positionComponent.outOfBound())
            guard let entity = positionComponent.entity else {
                continue
            }
            handleOutOfGame(entity: entity)
        }
    }

    func handleOutOfGame(entity: TFEntity) {
        guard let playerComponent = entity.component(ofType: PlayerComponent.self) else {
            return
        }
        print("HAndle out of game triggered")
        // TODO: Might need some change
        eventManager.add(LifeEvent(on: entity.id, at: CACurrentMediaTime(), reduceBy: 1, player: playerComponent.player))
        eventManager.add(RemoveEvent(on: entity.id, at: CACurrentMediaTime()))
    }
}
