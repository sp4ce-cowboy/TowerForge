//
//  MeleeUnit.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class MeleeUnit: BaseUnit {
    static let textureNames = ["melee-1", "melee-2"]
    static let size = CGSize(width: 300, height: 300)
    static let key = "melee"
    static let maxHealth = 100.0
    static let damage = 10.0

    init(position: CGPoint) {
        super.init(textureNames: MeleeUnit.textureNames, size: MeleeUnit.size, key: MeleeUnit.key, position: position, maxHealth: MeleeUnit.maxHealth)
        createDamageComponent()
    }

    private func createDamageComponent() {
        let damageComponent = DamageComponent(damage: MeleeUnit.damage)
        damageComponent.didAddToEntity(self)
        self.addComponent(damageComponent)
    }
}
