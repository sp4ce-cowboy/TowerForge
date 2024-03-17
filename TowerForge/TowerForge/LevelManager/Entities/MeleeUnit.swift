//
//  MeleeUnit.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class MeleeUnit: BaseUnit {
    static let textureNames = ["melee-1", "melee-2"]
    static let size = CGSize(width: 100, height: 100)
    static let key = "melee"
    static let maxHealth = 100.0
    static let damage = 10.0

    init(position: CGPoint, entityManager: EntityManager, attackRate: TimeInterval, velocity: CGVector) {
        super.init(textureNames: MeleeUnit.textureNames,
                   size: MeleeUnit.size,
                   key: MeleeUnit.key,
                   position: position,
                   maxHealth: MeleeUnit.maxHealth, entityManager: entityManager, velocity: velocity)
        self.addComponent(DamageComponent(attackRate: attackRate,
                                          attackPower: MeleeUnit.damage,
                                          temporary: false,
                                          entityManager: entityManager))
    }
}
