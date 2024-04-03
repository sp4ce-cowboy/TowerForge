//
//  ShootingSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import Foundation

class ShootingSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        let shootingComponents = entityManager.components(ofType: ShootingComponent.self).filter({ $0.canShoot })
        let targetableHealthComponents = entityManager.components(ofType: HealthComponent.self).filter({
            $0.entity?.hasComponent(ofType: PositionComponent.self) ?? false
        })

        for shootingComponent in shootingComponents {
            for healthComponent in targetableHealthComponents {
                let event = attemptShoot(with: shootingComponent, at: healthComponent)
                if event is DisabledEvent { continue }
                eventManager.add(event)
                break
            }
        }
    }

    func attemptShoot(with shootingComponent: ShootingComponent, at healthComponent: HealthComponent) -> TFEvent {
        guard shootingComponent.canShoot, let shootingEntity = shootingComponent.entity,
              let targetEntity = healthComponent.entity else {
            return DisabledEvent()
        }

        guard let shootingPlayer = shootingEntity.component(ofType: PlayerComponent.self)?.player,
              let targetPlayer = targetEntity.component(ofType: PlayerComponent.self)?.player,
              shootingPlayer != targetPlayer else {
            return DisabledEvent()
        }

        guard let shootingPosition = shootingEntity.component(ofType: PositionComponent.self)?.position,
              let targetPosition = targetEntity.component(ofType: PositionComponent.self)?.position else {
            return DisabledEvent()
        }

        let direction = shootingPlayer == .ownPlayer ? -1.0 : 1.0
        let distance = (shootingPosition.x - targetPosition.x) * direction

        guard distance > 0, distance <= shootingComponent.range,
              abs(shootingPosition.y - targetPosition.y) <= 50 else {
            return DisabledEvent()
        }

        shootingComponent.shoot()
        return SpawnEvent(ofType: shootingComponent.shootingType, timestamp: shootingComponent.lastShotTime,
                          position: shootingPosition, player: shootingPlayer)
    }
}
