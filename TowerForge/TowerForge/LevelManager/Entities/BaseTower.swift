//
//  BaseTower.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseTower: TFEntity {
    init(textureNames: [String],
         size: CGSize,
         key: String,
         position: CGPoint,
         maxHealth: CGFloat,
         entityManager: EntityManager) {
        super.init()

        createHealthComponent(maxHealth: maxHealth, entityManager: entityManager)
        createSpriteComponent(textureNames: textureNames, size: size, key: key, position: position)
        createPositionComponent(position: position)
    }

    private func createHealthComponent(maxHealth: CGFloat, entityManager: EntityManager) {
        let healthComponent = HealthComponent(maxHealth: maxHealth, entityManager: entityManager)
        self.addComponent(healthComponent)
    }
    private func createPositionComponent(position: CGPoint) {
        let positionComponent = PositionComponent(position: position)
        self.addComponent(positionComponent)
    }

    private func createSpriteComponent(textureNames: [String], size: CGSize, key: String, position: CGPoint) {
        let spriteComponent = SpriteComponent(textureNames: textureNames,
                                              height: size.height,
                                              width: size.width,
                                              position: position,
                                              animatableKey: key)
        self.addComponent(spriteComponent)
    }
}
