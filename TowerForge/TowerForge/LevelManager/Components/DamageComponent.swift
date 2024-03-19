//
//  MeleeComponent.swift
//  TowerForge
//
//  Created by MacBook Pro on 17/03/24.
//

import Foundation
import CoreGraphics
import SpriteKit

class DamageComponent: TFComponent {
    private let attackRate: TimeInterval
    private var lastAttackTime = TimeInterval(0)
    private let entityManager: EntityManager
    private let temporary: Bool
    let attackPower: CGFloat

    init(attackRate: TimeInterval, attackPower: CGFloat, temporary: Bool, entityManager: EntityManager) {
        self.attackRate = attackRate
        self.attackPower = attackPower
        self.entityManager = entityManager
        self.temporary = temporary
        super.init()
    }

    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)

        // Required components for the current Melee
        guard let entity = entity,
              let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }

        // Loop opposite team's entities
        for entity in entityManager.entities {
            guard let playerComponent = entity.component(ofType: PlayerComponent.self) else {
                return
            }
            if playerComponent.player == .ownPlayer {
                return
            }
            // Get opposite team's components
            guard let oppositeSpriteComponent = entity.component(ofType: SpriteComponent.self),
                  let oppositeHealthComponent = entity.component(ofType: HealthComponent.self) else {
                return
            }

            // Check collision with opposite team sprite component
            if oppositeSpriteComponent.node
                .calculateAccumulatedFrame().intersects(
                    spriteComponent.node.calculateAccumulatedFrame()) {

                // Check if can attack
                if CACurrentMediaTime() - lastAttackTime > attackRate {
                    lastAttackTime = CACurrentMediaTime()
                    oppositeHealthComponent.decreaseHealth(amount: attackPower)
                }

            }

            // If only used once, then remove from entity
            if temporary {
                entityManager.removeEntity(with: entity.id)
            }
        }
    }
}
