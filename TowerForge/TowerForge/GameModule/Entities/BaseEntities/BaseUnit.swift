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
        // Core Components
        self.addComponent(SpriteComponent(textureNames: textureNames, size: size, animatableKey: key))
        self.addComponent(PositionComponent(position: position))
        self.addComponent(MovableComponent(velocity: velocity))

        // Game Components
        self.addComponent(HealthComponent(maxHealth: maxHealth))
        self.addComponent(PlayerComponent(player: player))
        self.addComponent(ContactComponent(hitboxSize: size))
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

    override func onSeparate() {
        guard let movableComponent = self.component(ofType: MovableComponent.self) else {
            return
        }
        movableComponent.shouldMove = true
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

        movableComponent.shouldMove = false
        if let ownMovableComponent = self.component(ofType: MovableComponent.self) {
            ownMovableComponent.shouldMove = false
        }
        return nil
    }
}
