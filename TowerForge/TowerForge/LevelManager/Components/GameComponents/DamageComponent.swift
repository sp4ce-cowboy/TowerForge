//
//  MeleeComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
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

    var canDamage: Bool {
        CACurrentMediaTime() - lastAttackTime >= attackRate
    }

    func damage(_ healthComponent: HealthComponent) -> DamageEvent? {
        guard canDamage, let entityId = healthComponent.entity?.id else {
            return nil
        }

        guard let teamA = self.entity?.component(ofType: PlayerComponent.self)?.player,
              let teamB = healthComponent.entity?.component(ofType: PlayerComponent.self)?.player,
              teamA != teamB else {
            return nil
        }

        lastAttackTime = CACurrentMediaTime()
        return DamageEvent(on: entityId, at: lastAttackTime, with: attackPower)
    }
}
