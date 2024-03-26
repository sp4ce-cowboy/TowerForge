//
//  MeleeComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import QuartzCore

class DamageComponent: TFComponent {
    private let attackRate: TimeInterval
    private var lastAttackTime = TimeInterval(0)
    private let temporary: Bool
    let attackPower: CGFloat

    init(attackRate: TimeInterval, attackPower: CGFloat, temporary: Bool) {
        self.attackRate = attackRate
        self.attackPower = attackPower
        self.temporary = temporary
        super.init()
    }

    var canDamage: Bool {
        CACurrentMediaTime() - lastAttackTime >= attackRate
    }

    func damage(_ healthComponent: HealthComponent) -> TFEvent? {
        guard canDamage, let enemyId = healthComponent.entity?.id, let entityId = entity?.id else {
            return nil
        }

        guard let teamA = self.entity?.component(ofType: PlayerComponent.self)?.player,
              let teamB = healthComponent.entity?.component(ofType: PlayerComponent.self)?.player,
              teamA != teamB else {
            return nil
        }

        lastAttackTime = CACurrentMediaTime()
        let event = DamageEvent(on: enemyId, at: lastAttackTime, with: attackPower)

        if temporary {
            return event.concurrentlyWith(RemoveEvent(on: entityId, at: lastAttackTime))
        }
        return event
    }
}
