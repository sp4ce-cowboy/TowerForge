//
//  BaseTower.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseTower: TFEntity {
    init(textureNames: [String],
         size: CGSize,
         key: String,
         position: CGPoint,
         maxHealth: CGFloat,
         player: Player) {
        super.init()
        // Core Components
        self.addComponent(SpriteComponent(textureNames: textureNames, size: size, animatableKey: key))
        self.addComponent(PositionComponent(position: position))
        
        // Game Components
        self.addComponent(HealthComponent(maxHealth: maxHealth))
        self.addComponent(PlayerComponent(player: player))
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

    override func collide(with movableComponent: MovableComponent) -> (any TFEvent)? {
        guard let playerA = self.component(ofType: PlayerComponent.self)?.player,
              let playerB = movableComponent.entity?.component(ofType: PlayerComponent.self)?.player,
              playerA != playerB else {
            return nil
        }

        movableComponent.isColliding = true
        return nil
    }
}
