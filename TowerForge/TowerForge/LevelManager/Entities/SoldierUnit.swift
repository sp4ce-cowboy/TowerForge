//
//  SoldierUnit.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import Foundation

class SoldierUnit: BaseUnit, Spawnable {
    static let title: String = "soldier"
    static let textureNames = ["Shooter-1", "Shooter-2"]
    static let size = CGSize(width: 100, height: 100)
    static let key = "shoot"
    static let maxHealth = 100.0
    static let damage = 10.0
    static var cost = 5
    static let attackRate = 10.0
    static let velocity = CGVector(dx: -10.0, dy: 0.0)

    required init(position: CGPoint, team: Team) {
        super.init(textureNames: SoldierUnit.textureNames,
                   size: SoldierUnit.size,
                   key: SoldierUnit.key,
                   position: position,
                   maxHealth: SoldierUnit.maxHealth,
                   velocity: SoldierUnit.velocity,
                   team: team)

        self.addComponent(ShootingComponent(fireRate: SoldierUnit.attackRate,
                                            range: 1.0,
                                            attackPower: 10.0))
    }
}
