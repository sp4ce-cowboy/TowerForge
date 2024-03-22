//
//  Arrow.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class Arrow: BaseProjectile {
    static let textureNames: [String] = []
    static let size = CGSize(width: 10, height: 10)
    static let key = "arrow"
    static let damage = 5.0

    init(position: CGPoint, velocity: CGVector, attackRate: TimeInterval) {
        super.init(textureNames: Arrow.textureNames,
                   size: Arrow.size,
                   key: Arrow.key,
                   position: position,
                   velocity: velocity)
        self.addComponent(DamageComponent(attackRate: attackRate,
                                          attackPower: Arrow.damage,
                                          temporary: true))
    }

    override func collide(with other: any Collidable) -> TFEvent? {
        let superEvent = super.collide(with: other)
        guard let damageComponent = self.component(ofType: DamageComponent.self) else {
            return superEvent
        }
        if let superEvent = superEvent {
            return superEvent.concurrentlyWith(other.collide(with: damageComponent))
        }
        return other.collide(with: damageComponent)
    }

    override func collide(with healthComponent: HealthComponent) -> TFEvent? {
        guard let damageComponent = self.component(ofType: DamageComponent.self) else {
            return nil
        }
        return damageComponent.damage(healthComponent)
    }
}
