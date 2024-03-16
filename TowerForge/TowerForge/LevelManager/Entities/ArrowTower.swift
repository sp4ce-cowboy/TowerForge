//
//  ArrowTower.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class ArrowTower: BaseTower {
    static let textureNames = ["melee-1", "melee-2"]
    static let size = CGSize(width: 300, height: 300)
    static let key = "arrowTower"
    static let maxHealth = 200.0
    static let damage = 10.0
    static let fireRate = 1.0

    init(position: CGPoint, entityManager: EntityManager) {
        super.init(textureNames: ArrowTower.textureNames,
                   size: ArrowTower.size,
                   key: ArrowTower.key,
                   position: position,
                   maxHealth: ArrowTower.maxHealth, entityManager: entityManager)
        self.addComponent(ShootingComponent(fireRate: ArrowTower.fireRate, range: 1.0, entityManager: entityManager, attackPower: ArrowTower.damage))
    }
}
