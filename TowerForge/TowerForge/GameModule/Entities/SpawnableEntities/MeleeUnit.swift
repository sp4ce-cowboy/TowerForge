//
//  MeleeUnit.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class MeleeUnit: BaseUnit, PlayerSpawnable {
    static let title: String = "melee"
    static let textureNames = ["melee-1", "melee-2"]
    static let size = CGSize(width: 100, height: 100)
    static let key = "melee"
    static let maxHealth = 100.0
    static let damage = 10.0
    static var cost = 10
    static let attackRate = 1.0
    static let velocity = CGVector(dx: 30.0, dy: 0.0)

    required init(position: CGPoint, player: Player) {
        super.init(textureNames: MeleeUnit.textureNames,
                   size: MeleeUnit.size,
                   key: MeleeUnit.key,
                   position: position,
                   maxHealth: MeleeUnit.maxHealth,
                   velocity: MeleeUnit.velocity,
                   player: player)
        self.addComponent(DamageComponent(attackRate: MeleeUnit.attackRate,
                                          attackPower: MeleeUnit.damage,
                                          temporary: false))
    }

    required init(position: CGPoint, player: Player, id: UUID) {
        super.init(textureNames: MeleeUnit.textureNames,
                   size: MeleeUnit.size,
                   key: MeleeUnit.key,
                   position: position,
                   maxHealth: MeleeUnit.maxHealth,
                   velocity: MeleeUnit.velocity,
                   player: player,
                   id: id)
        self.addComponent(DamageComponent(attackRate: MeleeUnit.attackRate,
                                          attackPower: MeleeUnit.damage,
                                          temporary: false))
    }

    override func collide(with other: any Collidable) -> TFEvent {
        let superEvent = super.collide(with: other)
        guard let damageComponent = self.component(ofType: DamageComponent.self) else {
            return superEvent
        }
        return superEvent.concurrentlyWith(other.collide(with: damageComponent))
    }

    override func collide(with healthComponent: HealthComponent) -> TFEvent {
        guard let damageComponent = self.component(ofType: DamageComponent.self) else {
            return DisabledEvent()
        }
        return damageComponent.damage(healthComponent)
    }
}
