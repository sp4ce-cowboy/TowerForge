//
//  BaseProjectiles.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseProjectiles: TFEntity {
    init(textureNames: [String], size: CGSize, key: String, position: CGPoint) {
        super.init()

        createSpriteComponent(textureNames: textureNames, size: size, key: key, position: position)
        createMovableComponent(position: position)
    }

    private func createSpriteComponent(textureNames: [String], size: CGSize, key: String, position: CGPoint) {
        let spriteComponent = SpriteComponent(textureNames: textureNames, height: size.height, width: size.width, position: position, animatableKey: key)
        spriteComponent.didAddToEntity(self)
        self.addComponent(spriteComponent)
    }

    private func createMovableComponent(position: CGPoint) {
        let movableComponent = MovableComponent(position: position)
        movableComponent.didAddToEntity(self)
        self.addComponent(movableComponent)
    }
}
