//
//  MovableComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 15/03/24.
//

import Foundation
import CoreGraphics

class MovableComponent: TFComponent {
    var velocity: CGVector
    var position: CGPoint

    init(position: CGPoint, velocity: CGVector = .zero) {
        self.velocity = velocity
        self.position = position
        super.init()
    }

    override func update(deltaTime: TimeInterval) {
        guard let entity = entity,
              let positionComponent = entity.component(ofType: PositionComponent.self),
              let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }

        let finalX = positionComponent.position.x + velocity.dx * CGFloat(deltaTime)
        let finalY = positionComponent.position.y + velocity.dy * CGFloat(deltaTime)
        positionComponent.changeTo(to: CGPoint(x: finalX, y: finalY))
        spriteComponent.node.position = positionComponent.position
    }
}
