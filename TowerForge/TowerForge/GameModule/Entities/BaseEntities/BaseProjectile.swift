//
//  BaseProjectile.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseProjectile: TFEntity {
    init(textureNames: [String], size: CGSize, key: String, position: CGPoint,
         player: Player, velocity: CGVector = .zero) {
        super.init()
        // Core Components
        self.addComponent(SpriteComponent(textureNames: textureNames, size: size, animatableKey: key))
        self.addComponent(PositionComponent(position: position))
        self.addComponent(MovableComponent(velocity: velocity))

        // Game Components
        self.addComponent(PlayerComponent(player: player))
        self.addComponent(ContactComponent(hitboxSize: size))
    }
}
