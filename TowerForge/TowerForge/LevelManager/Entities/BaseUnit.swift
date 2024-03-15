//
//  BaseUnit.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseUnit: TFEntity {
    init(textureNames: [String], size: CGSize, key: String, position: CGPoint, maxHealth: Float) {
        super.init()

        createHealthComponent(maxHealth: maxHealth)
        createSpriteComponent(textureNames: textureNames, size: size, key: key, position: position)
        createMovableComponent(position: position)
    }

    private func createHealthComponent(maxHealth: Float) {
        let healthComponent = HealthComponent(maxHealth: maxHealth)
        healthComponent.didAddToEntity(self)
        self.components.append(healthComponent)
    }

    private func createSpriteComponent(textureNames: [String], size: CGSize, key: String, position: CGPoint) {
        let spriteComponent = SpriteComponent(textureNames: textureNames, height: size.height, width: size.width, position: position, animatableKey: key)
        spriteComponent.didAddToEntity(self)
        self.components.append(spriteComponent)
    }

    private func createMovableComponent(position: CGPoint) {
        let movableComponent = MovableComponent(position: position)
        movableComponent.didAddToEntity(self)
        self.components.append(movableComponent)
    }
}
