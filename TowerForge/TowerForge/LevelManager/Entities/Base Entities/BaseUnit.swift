//
//  BaseUnit.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseUnit: TFEntity {
    init(textureNames: [String],
         size: CGSize,
         key: String,
         position: CGPoint,
         maxHealth: CGFloat,
         entityManager: EntityManager,
         velocity: CGVector,
         team: Team) {
        super.init()
        createHealthComponent(maxHealth: maxHealth, entityManager: entityManager)
        createSpriteComponent(textureNames: textureNames, size: size, key: key, position: position)
        createMovableComponent(position: position, velocity: velocity)
        createPositionComponent(position: position)
        createPlayerComponent(team: team)
    }

    override func collide(with other: any Collidable) -> TFEvent? {
        let superEvent = super.collide(with: other)
        guard let healthComponent = self.component(ofType: HealthComponent.self) else {
            return superEvent
        }

        if let superEvent = superEvent {
            return superEvent.concurrentlyWith(other.collide(with: healthComponent))
        }
        return other.collide(with: healthComponent)
    }

    override func collide(with damageComponent: DamageComponent) -> TFEvent? {
        guard let healthComponent = self.component(ofType: HealthComponent.self) else {
            return nil
        }
        // No call to super here as super is done on collide with Collidable above.
        return damageComponent.damage(healthComponent)
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

    private func createMovableComponent(position: CGPoint, velocity: CGVector) {
        let movableComponent = MovableComponent(position: position, velocity: velocity)
        self.addComponent(movableComponent)
    }
    private func createPlayerComponent(team: Team) {
        let playerComponent = PlayerComponent(player: team.player)
        self.addComponent(playerComponent)
    }
}
