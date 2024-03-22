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
         velocity: CGVector,
         player: Player) {
        super.init()
        createPlayerComponent(player: player)
        createHealthComponent(maxHealth: maxHealth)
        createSpriteComponent(textureNames: textureNames, size: size, key: key, position: position)
        createMovableComponent(position: position, velocity: velocity)
        createPositionComponent(position: position)
    }

    override func collide(with other: any Collidable) -> TFEvent? {
        let superEvent = super.collide(with: other)
        guard let healthComponent = self.component(ofType: HealthComponent.self),
              let movableComponent = self.component(ofType: MovableComponent.self) else {
            return superEvent
        }

        let event = other.collide(with: healthComponent)?
            .concurrentlyWith(other.collide(with: movableComponent)) ?? other.collide(with: movableComponent)

        return superEvent?.concurrentlyWith(event) ?? event
    }

    override func collide(with damageComponent: DamageComponent) -> TFEvent? {
        guard let healthComponent = self.component(ofType: HealthComponent.self) else {
            return nil
        }
        // No call to super here as super is done on collide with Collidable above.
        return damageComponent.damage(healthComponent)
    }

    override func collide(with movableComponent: MovableComponent) -> TFEvent? {
        guard let playerA = self.component(ofType: PlayerComponent.self)?.player,
              let playerB = movableComponent.entity?.component(ofType: PlayerComponent.self)?.player,
              playerA != playerB else {
            return nil
        }

        movableComponent.isColliding = true
        if let component = self.component(ofType: MovableComponent.self) {
            component.isColliding = true
        }

        return nil
    }

    private func createHealthComponent(maxHealth: CGFloat) {
        let healthComponent = HealthComponent(maxHealth: maxHealth)
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

    private func createPlayerComponent(player: Player) {
        let playerComponent = PlayerComponent(player: player)
        self.addComponent(playerComponent)
    }
}
