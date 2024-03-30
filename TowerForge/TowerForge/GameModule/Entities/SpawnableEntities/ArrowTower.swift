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
    static let range = 400.0
    static let fireRate = 1.0

    required init(position: CGPoint, player: Player) {
        super.init(textureNames: ArrowTower.textureNames,
                   size: ArrowTower.size,
                   key: ArrowTower.key,
                   position: position,
                   maxHealth: ArrowTower.maxHealth,
                   player: player)
        self.addComponent(ShootingComponent(fireRate: ArrowTower.fireRate,
                                            range: ArrowTower.range,
                                            attackPower: ArrowTower.damage))
    }
}
