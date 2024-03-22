//
//  ShootingComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 15/03/24.
//

import Foundation
import SpriteKit

class ShootingComponent: TFComponent {
    var fireRate: TimeInterval // Delay between shots
    var range: CGFloat
    private var lastShotTime = TimeInterval(0)
    let attackPower: CGFloat

    init(fireRate: TimeInterval, range: CGFloat, attackPower: CGFloat) {
        self.fireRate = fireRate
        self.range = range
        self.attackPower = attackPower
        super.init()
    }

//    override func update(deltaTime: TimeInterval) {
//        super.update(deltaTime: deltaTime)
//
//        // Required components for the current Melee
//        guard let entity = entity,
//              let spriteComponent = entity.component(ofType: SpriteComponent.self),
//              let positionComponent = entity.component(ofType: PositionComponent.self) else {
//            return
//        }
//
//        // Loop opposite team's entities
//        for entity in entityManager.entities {
//            guard let playerComponent = entity.component(ofType: PlayerComponent.self) else {
//                return
//            }
//            if playerComponent.player == .ownPlayer {
//                return
//            }
//            // Get opposite team's components
//            guard let oppositeSpriteComponent = entity.component(ofType: SpriteComponent.self),
//                  let oppositeHealthComponent = entity.component(ofType: HealthComponent.self),
//                  let oppositePositionComponent = entity.component(ofType: PositionComponent.self) else {
//                return
//            }
//
//            // Get the horizontal distance
//            let distanceBetween = (positionComponent.position.x - oppositePositionComponent.position.x)
//
//            // Check if within range
//            if distanceBetween < range {
//                // TODO : Change the hard coded velocity value
//                let arrow = Arrow(position: positionComponent.position,
//                                  velocity: playerComponent.player.getDirectionVelocity(),
//                                  attackRate: 1.0,
//                                  entityManager: entityManager)
//                guard let arrowSpriteComponent = arrow.component(ofType: SpriteComponent.self) else {
//                    return
//                }
//
//                // Check if can attack
//                if CACurrentMediaTime() - lastShotTime > fireRate {
//                    lastShotTime = CACurrentMediaTime()
//                }
//            }
//        }
}
