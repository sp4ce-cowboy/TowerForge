//
//  WizardBall.swift
//  TowerForge
//
//  Created by Vanessa Mae on 31/03/24.
//

import Foundation

class WizardBall: BaseProjectile {
    static let textureNames: [String] = ["Wizard-ball-0"]
    static let size = CGSize(width: 10, height: 10)
    static let key = "wizard-ball"
    static let damage = 5.0
    static let attackRate = 1.0
    static let velocity = CGVector(dx: 100, dy: 0)

    required init(position: CGPoint, player: Player) {
        super.init(textureNames: WizardBall.textureNames,
                   size: WizardBall.size,
                   key: WizardBall.key,
                   position: position,
                   player: player,
                   velocity: WizardBall.velocity)
        self.addComponent(DamageComponent(attackRate: WizardBall.attackRate,
                                          attackPower: WizardBall.damage,
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
