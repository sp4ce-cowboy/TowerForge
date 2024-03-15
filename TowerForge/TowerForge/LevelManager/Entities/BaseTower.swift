//
//  BaseTower.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseTower: TFEntity {
    init(textureNames: [String], size: CGSize, key: String, position: CGPoint, maxHealth: CGFloat) {
        super.init()

        createHealthComponent(maxHealth: maxHealth)
        createSpriteComponent(textureNames: textureNames, size: size, key: key, position: position)
    }

    private func createHealthComponent(maxHealth: CGFloat) {
        let healthComponent = HealthComponent(maxHealth: maxHealth)
        healthComponent.didAddToEntity(self)
        self.addComponent(healthComponent)
    }

    private func createSpriteComponent(textureNames: [String], size: CGSize, key: String, position: CGPoint) {
        let spriteComponent = SpriteComponent(textureNames: textureNames, height: size.height, width: size.width, position: position, animatableKey: key)
        spriteComponent.didAddToEntity(self)
        self.addComponent(spriteComponent)
    }
}
