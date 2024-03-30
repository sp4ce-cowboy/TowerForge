//
//  HomeSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import UIKit

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
        guard !playerHomeComponentArr.contains(where: { $0.points < type.cost }) else {
            return
        }

        // Reduce points
        playerHomeComponentArr.forEach({ $0.decreasePoints(type.cost) })

        let snapPosition = getSnapPosition(at: position, for: player, with: type)
        let spawnEvent = SpawnEvent(ofType: type, timestamp: CACurrentMediaTime(),
                                    position: snapPosition, player: player)
        eventManager.add(spawnEvent)
    }

    private func getSnapPosition<T: TFEntity & PlayerSpawnable>(at requestedPosition: CGPoint,
                                                                for player: Player, with type: T.Type) -> CGPoint {
        // Normalise to own player position
        let normalisedPosition = normalise(position: requestedPosition, for: player)

        // Snap x position according to unit type
        let snappedPosition = snap(position: normalisedPosition, for: type)

        // Undo normalise if needed
        let denormalisedPosition = normalise(position: snappedPosition, for: player)

        return gridDelegate.snap(position: denormalisedPosition)
    }

    private func normalise(position: CGPoint, for player: Player) -> CGPoint {
        guard player == .oppositePlayer else {
            return position
        }

        return CGPoint(x: gridDelegate.playableBounds.maxX - position.x, y: position.y)
    }

    private func snap<T: TFEntity & PlayerSpawnable>(position: CGPoint, for type: T.Type) -> CGPoint {
        if type is BaseUnit.Type {
            return CGPoint(x: 0, y: position.y)
        } else if type is BaseTower.Type && position.x > gridDelegate.playableBounds.midX {
            return CGPoint(x: gridDelegate.playableBounds.midX, y: position.y)
        }
        return position
    }
}
