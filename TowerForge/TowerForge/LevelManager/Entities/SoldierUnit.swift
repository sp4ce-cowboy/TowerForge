//
//  SoldierUnit.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import Foundation

class SoldierUnit: BaseUnit {
    static let textureNames = ["Shooter-1", "Shooter-2"]
    static let size = CGSize(width: 100, height: 100)
    static let key = "shoot"
    static let maxHealth = 100.0
    static let damage = 10.0
    static let cost = 5

    init(position: CGPoint, entityManager: EntityManager, attackRate: TimeInterval, velocity: CGVector, team: Team) {
        super.init(textureNames: SoldierUnit.textureNames,
                   size: SoldierUnit.size,
                   key: SoldierUnit.key,
                   position: position,
                   maxHealth: SoldierUnit.maxHealth,
                   entityManager: entityManager,
                   cost: SoldierUnit.cost,
                   velocity: velocity,
                   team: team)

        self.addComponent(ShootingComponent(fireRate: attackRate,
                                            range: 1.0,
                                            entityManager: entityManager,
                                            attackPower: 10.0
                                           ))
    }
}
