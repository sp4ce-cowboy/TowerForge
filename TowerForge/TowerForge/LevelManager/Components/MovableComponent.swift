//
//  MovableComponent.swift
//  TowerForge
//
//  Created by MacBook Pro on 15/03/24.
//

import Foundation

class MovableComponent: TFComponent {
    public var velocity: CGVector
    public var position: CGPoint
    
    init(position: CGPoint, velocity: CGVector = .zero) {
        self.velocity = velocity
        self.position = position
        super.init()
    }
    
    func move(deltaTime: CGFloat) {
        /// TODO 2: To be used later when entity is set up
        guard let entity = entity else {
            return
        }
        let dummySpriteComponent = SpriteComponent(textureNames: ["melee-1"], height: 300, width: 300, position: CGPoint(x: 100, y: 100), animatableKey: "melee")
        dummySpriteComponent.node.position.x += velocity.dx * deltaTime
        dummySpriteComponent.node.position.y += velocity.dy * deltaTime
    }
}
