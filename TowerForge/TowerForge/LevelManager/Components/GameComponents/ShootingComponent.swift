//
//  ShootingComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 15/03/24.
//

import Foundation
import SpriteKit

class ShootingComponent: TFComponent {
    var fireRate: TimeInterval // Delay between shots
    var range: CGFloat
    private var lastShotTime = TimeInterval(0)
    let attackPower: CGFloat

    init(fireRate: TimeInterval, range: CGFloat, attackPower: CGFloat) {
        self.fireRate = fireRate
        self.range = range
        self.attackPower = attackPower
        super.init()
    }

    var canShoot: Bool {
        CACurrentMediaTime() - lastShotTime >= fireRate
    }

    func shoot(_ healthComponent: HealthComponent) -> SpawnEvent? {
        guard canShoot, let entityA = self.entity, let entityB = healthComponent.entity else {
            return nil
        }

        guard let playerA = entityA.component(ofType: PlayerComponent.self)?.player,
              let playerB = entityB.component(ofType: PlayerComponent.self)?.player,
              playerA != playerB else {
            return nil
        }

        guard let positionA = entityA.component(ofType: PositionComponent.self)?.position,
              let positionB = entityB.component(ofType: PositionComponent.self)?.position,
              abs(positionA.x - positionB.x) <= range else {
            return nil
        }

        lastShotTime = CACurrentMediaTime()
        return SpawnEvent(ofType: Arrow.self, timestamp: lastShotTime, position: positionA, player: playerA)
    }
}
