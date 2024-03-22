//
//  Arrow.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation
import SpriteKit

class Arrow: BaseProjectile, Spawnable {
    static let textureNames: [String] = []
    static let size = CGSize(width: 10, height: 10)
    static let key = "arrow"
    static let damage = 5.0
    static let attackRate = 1.0
    static let velocity = CGVector(dx: 100, dy: 0)

    required init(position: CGPoint, player: Player) {
        super.init(textureNames: Arrow.textureNames,
                   size: Arrow.size,
                   key: Arrow.key,
                   position: position,
                   player: player,
                   velocity: Arrow.velocity)
        self.addComponent(DamageComponent(attackRate: Arrow.attackRate,
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
