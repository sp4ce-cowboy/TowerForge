//
//  HomeSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import QuartzCore

class HomeSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager
    var gridDelegate: GridDelegate

    init(entityManager: EntityManager, eventManager: EventManager, gridDelegate: GridDelegate) {
        self.entityManager = entityManager
        self.eventManager = eventManager
        self.gridDelegate = gridDelegate
    }

    func update(within time: CGFloat) {
        let homeComponents = entityManager.components(ofType: HomeComponent.self)
        for homeComponent in homeComponents {
            homeComponent.update(deltaTime: time)
        }
    }

    func reduceLife(for player: Player, reduction life: Int) {
        let playerHomeComponentArr = entityManager.components(ofType: HomeComponent.self).filter(({
            $0.entity?.component(ofType: PlayerComponent.self)?.player == player
        }))
        for playerHomeComponent in playerHomeComponentArr {
            _ = playerHomeComponent.decreaseLife(by: life)
        }
    }
    func changeDeathCount(for player: Player, change: Int) {
        let playerHomeComponentArr = entityManager.components(ofType: HomeComponent.self).filter(({
            $0.entity?.component(ofType: PlayerComponent.self)?.player == player
        }))
        for playerHomeComponent in playerHomeComponentArr {
            playerHomeComponent.changeDeathCount(change)
        }
    }
    func attemptSpawn<T: TFEntity & PlayerSpawnable>(at position: CGPoint, ofType type: T.Type, for player: Player) {
        // Get HomeComponent for the player
        let playerHomeComponentArr = entityManager.components(ofType: HomeComponent.self).filter(({
            $0.entity?.component(ofType: PlayerComponent.self)?.player == player
        }))
        guard !playerHomeComponentArr.isEmpty, position.y >= gridDelegate.UNIT_SELECTION_NODE_HEIGHT else {
            return
        }

        // Check if they have enough points to spawn
        for playerHomeComponent in playerHomeComponentArr {
            guard playerHomeComponent.points >= type.cost else {
                return
            }
            playerHomeComponent.decreasePoints(type.cost)
        }

        let snapPosition = CGPoint(x: position.x, y: gridDelegate.snapYPosition(yPosition: position.y))
        let spawnEvent = SpawnEvent(ofType: type, timestamp: CACurrentMediaTime(),
                                    position: snapPosition, player: player)
        eventManager.add(spawnEvent)
    }
}
