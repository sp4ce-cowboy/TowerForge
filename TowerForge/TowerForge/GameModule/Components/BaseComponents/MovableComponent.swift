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
    var shouldMove = true

    init(velocity: CGVector = .zero) {
        self.velocity = velocity
        super.init()
    }

    func updatePosition(with vector: CGVector) {
        guard let positionComponent = entity?.component(ofType: PositionComponent.self) else {
            return
        }
        positionComponent.move(by: vector)
    }

    override func update(deltaTime: TimeInterval) {
        guard shouldMove, let entity = entity,
              let positionComponent = entity.component(ofType: PositionComponent.self),
              let playerComponent = entity.component(ofType: PlayerComponent.self) else {
            return
        }

        let directionVelocity = playerComponent.player.getDirectionVelocity()
        let finalX = positionComponent.position.x + (velocity.dx * CGFloat(deltaTime) * directionVelocity.dx)
        let finalY = positionComponent.position.y + (velocity.dy * CGFloat(deltaTime) * directionVelocity.dy)

        positionComponent.changeTo(to: CGPoint(x: finalX, y: finalY))
    }
}
