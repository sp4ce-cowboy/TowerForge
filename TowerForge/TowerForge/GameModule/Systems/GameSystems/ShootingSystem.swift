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
                guard let event = shootingComponent.shoot(healthComponent) else {
                    continue
                }

                eventManager.add(event)
                break
            }
        }
    }
}
