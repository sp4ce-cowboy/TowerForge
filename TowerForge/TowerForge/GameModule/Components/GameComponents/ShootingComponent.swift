//
//  ShootingComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 15/03/24.
//

import QuartzCore

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
              let positionB = entityB.component(ofType: PositionComponent.self)?.position else {
            return nil
        }

        let direction = playerA == .ownPlayer ? -1.0 : 1.0
        let distance = (positionA.x - positionB.x) * direction

        guard distance > 0, distance <= range, abs(positionA.y - positionB.y) <= 50 else {
            return nil
        }

        lastShotTime = CACurrentMediaTime()
        return SpawnEvent(ofType: Bullet.self, timestamp: lastShotTime, position: positionA, player: playerA)
    }
}
