//
//  MeleeUnit.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class MeleeUnit: BaseUnit, Spawnable {
    static let title: String = "melee"
    static let textureNames = ["melee-1", "melee-2"]
    static let size = CGSize(width: 100, height: 100)
    static let key = "melee"
    static let maxHealth = 100.0
    static let damage = 10.0
    static var cost = 10
    static let attackRate = 1.0
    static let velocity = CGVector(dx: 10.0, dy: 0.0)

    required init(position: CGPoint, entityManager: EntityManager, player: Player) {
        super.init(textureNames: MeleeUnit.textureNames,
                   size: MeleeUnit.size,
                   key: MeleeUnit.key,

                   position: position,
                   maxHealth: MeleeUnit.maxHealth,
                   entityManager: entityManager,
                   velocity: MeleeUnit.velocity,
                   player: player)
        self.addComponent(DamageComponent(attackRate: MeleeUnit.attackRate,
                                          attackPower: MeleeUnit.damage,
                                          temporary: false,
                                          entityManager: entityManager))
    }

    override func collide(with other: any Collidable) -> (any TFEvent)? {
        let superEvent = super.collide(with: other)
        guard let damageComponent = self.component(ofType: DamageComponent.self) else {
            return superEvent
        }
        if let superEvent = superEvent {
            return superEvent.concurrentlyWith(other.collide(with: damageComponent))
        }
        return other.collide(with: damageComponent)
    }

    override func collide(with healthComponent: HealthComponent) -> (any TFEvent)? {
        guard let damageComponent = self.component(ofType: DamageComponent.self) else {
            return nil
        }
        return damageComponent.damage(healthComponent)
    }
}
