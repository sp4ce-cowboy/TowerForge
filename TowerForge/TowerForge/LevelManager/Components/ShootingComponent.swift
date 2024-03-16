//
//  ShootingComponent.swift
//  TowerForge
//
//  Created by MacBook Pro on 15/03/24.
//

import Foundation

/// TODO 4 : Once entity is completed
class ShootingComponent: TFComponent {
    var fireRate: TimeInterval // Delay between shots
    private var lastShotTime: TimeInterval = 0

    init(fireRate: TimeInterval) {
        self.fireRate = fireRate
    }

    override func update(deltaTime: TimeInterval) {
        lastShotTime += deltaTime
    }

    func shoot() {
        lastShotTime = 0
    }

    var canShoot: Bool {
        lastShotTime >= fireRate
    }
}
