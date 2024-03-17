//
//  BaseProjectile.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseProjectile: TFEntity {
    init(textureNames: [String], size: CGSize, key: String, position: CGPoint, velocity: CGVector = .zero) {
        super.init()

        createSpriteComponent(textureNames: textureNames, size: size, key: key, position: position)
        createMovableComponent(position: position, velocity: velocity)
        createPositionComponent(position: position)
    }

    private func createSpriteComponent(textureNames: [String], size: CGSize, key: String, position: CGPoint) {
        let spriteComponent = SpriteComponent(textureNames: textureNames,
                                              height: size.height,
                                              width: size.width,
                                              position: position,
                                              animatableKey: key)
        self.addComponent(spriteComponent)
    }
    private func createPositionComponent(position: CGPoint) {
        let positionComponent = PositionComponent(position: position)
        self.addComponent(positionComponent)
    }
    
    private func createMovableComponent(position: CGPoint, velocity: CGVector) {
        let movableComponent = MovableComponent(position: position, velocity: velocity)
        self.addComponent(movableComponent)
    }
}
