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
                guard let event = attemptShoot(with: shootingComponent, at: healthComponent) else {
                    continue
                }
                eventManager.add(event)
                break
            }
        }
    }

    func attemptShoot(with shootingComponent: ShootingComponent, at healthComponent: HealthComponent) -> TFEvent? {
        guard shootingComponent.canShoot, let shootingEntity = shootingComponent.entity,
              let targetEntity = healthComponent.entity else {
            return nil
        }

        guard let shootingPlayer = shootingEntity.component(ofType: PlayerComponent.self)?.player,
              let targetPlayer = targetEntity.component(ofType: PlayerComponent.self)?.player,
              shootingPlayer != targetPlayer else {
            return nil
        }

        guard let shootingPosition = shootingEntity.component(ofType: PositionComponent.self)?.position,
              let targetPosition = targetEntity.component(ofType: PositionComponent.self)?.position else {
            return nil
        }

        let direction = shootingPlayer == .ownPlayer ? -1.0 : 1.0
        let distance = (shootingPosition.x - targetPosition.x) * direction

        guard distance > 0, distance <= shootingComponent.range,
              abs(shootingPosition.y - targetPosition.y) <= 50 else {
            return nil
        }

        shootingComponent.shoot()
        return SpawnEvent(ofType: Bullet.self, timestamp: shootingComponent.lastShotTime,
                          position: shootingPosition, player: shootingPlayer)
    }
}
