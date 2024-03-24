//
//  HomeSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import Foundation
import SpriteKit

class HomeSystem: TFSystem {
    var isActive = true
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?
    var gridDelegate: GridDelegate

    init(entityManager: EntityManager, eventManager: EventManager, gridDelegate: GridDelegate) {
        self.entityManager = entityManager
        self.eventManager = eventManager
        self.gridDelegate = gridDelegate
    }

    func update(within time: CGFloat) {
        guard let entityManager = entityManager else {
            return
        }

        let homeComponents = entityManager.components(ofType: HomeComponent.self)
        for homeComponent in homeComponents {
            homeComponent.update(deltaTime: time)
        }
    }

    func attemptSpawn<T: TFEntity & PlayerSpawnable>(at position: CGPoint, ofType type: T.Type, for player: Player) {
        guard let entityManager = entityManager else {
            return
        }

        // Get HomeComponent for the player
        let playerHomeComponentArr = entityManager.components(ofType: HomeComponent.self).filter(({
            $0.entity?.component(ofType: PlayerComponent.self)?.player == player
        }))
        guard !playerHomeComponentArr.isEmpty else {
            return
        }
        let playerHomeComponent = playerHomeComponentArr[0]

        // Check if they have enough points to spawn
        guard playerHomeComponent.points >= type.cost else {
            return
        }

        playerHomeComponent.decreasePoints(type.cost)
        let snapPosition = CGPoint(x: position.x, y: gridDelegate.snapYPosition(yPosition: position.y))
        let spawnEvent = SpawnEvent(ofType: type, timestamp: CACurrentMediaTime(), position: snapPosition, player: player)
        eventManager?.add(spawnEvent)
    }
}
