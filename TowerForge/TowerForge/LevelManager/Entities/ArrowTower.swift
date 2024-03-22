//
//  ArrowTower.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class ArrowTower: BaseTower, PlayerSpawnable {
    static let title: String = "arrowTower"
    static let textureNames = ["LightHouse-1"]
    static let size = CGSize(width: 100, height: 100)
    static let key = "arrowTower"
    static let maxHealth = 200.0
    static let damage = 10.0
    static var cost = 10
    static let fireRate = 1.0

    required init(position: CGPoint, team: Team) {
        super.init(textureNames: ArrowTower.textureNames,
                   size: ArrowTower.size,
                   key: ArrowTower.key,
                   position: position,
                   maxHealth: ArrowTower.maxHealth,
                   team: team)
        self.addComponent(ShootingComponent(fireRate: ArrowTower.fireRate,
                                            range: 1.0,
                                            attackPower: ArrowTower.damage))
    }
}
