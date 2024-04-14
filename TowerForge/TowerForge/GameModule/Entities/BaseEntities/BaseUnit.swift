//
//  BaseUnit.swift
//  TowerForge
//
//  Created by Zheng Ze on 15/3/24.
//

import Foundation

class BaseUnit: TFEntity {
    static let zPosition: CGFloat = 100
    init(textureNames: [String],
         size: CGSize,
         key: String,
         position: CGPoint,
         maxHealth: CGFloat,
         velocity: CGVector,
         player: Player,
         id: UUID = UUID()) {
        super.init(id: id)
        // Core Components
        self.addComponent(SpriteComponent(textureNames: textureNames, size: size,
                                          animatableKey: key, zPosition: BaseUnit.zPosition))
        self.addComponent(PositionComponent(position: position))
        self.addComponent(MovableComponent(velocity: velocity))

        // Game Components
        self.addComponent(HealthComponent(maxHealth: maxHealth))
        self.addComponent(PlayerComponent(player: player))
        self.addComponent(ContactComponent(hitboxSize: size))
    }

    override func collide(with other: any Collidable) -> [TFEvent] {
        var events = super.collide(with: other)
        if let healthComponent = self.component(ofType: HealthComponent.self) {
            events.append(contentsOf: other.collide(with: healthComponent))
        }
        if let movableComponent = self.component(ofType: MovableComponent.self) {
            events.append(contentsOf: other.collide(with: movableComponent))
        }

        return events
    }

    override func onSeparate() {
        guard let movableComponent = self.component(ofType: MovableComponent.self) else {
            return
        }
        movableComponent.shouldMove = true
    }

    override func collide(with damageComponent: DamageComponent) -> [TFEvent] {
        guard let healthComponent = self.component(ofType: HealthComponent.self) else {
            return []
        }
        // No call to super here as super is done on collide with Collidable above.
        return damageComponent.damage(healthComponent)
    }

    override func collide(with movableComponent: MovableComponent) -> [TFEvent] {
        if let playerA = self.component(ofType: PlayerComponent.self)?.player,
              let playerB = movableComponent.entity?.component(ofType: PlayerComponent.self)?.player,
              playerA != playerB {
            movableComponent.shouldMove = false
        }

        return []
    }
}
