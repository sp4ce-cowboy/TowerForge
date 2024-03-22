//
//  HealthComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 15/03/24.
//

import Foundation

class HealthComponent: TFComponent {
    var currentHealth: CGFloat
    var maxHealth: CGFloat
    private let entityManager: EntityManager
    var isZero: Bool {
        currentHealth.isZero
    }

    init(maxHealth: CGFloat, entityManager: EntityManager) {
        self.currentHealth = maxHealth
        self.maxHealth = maxHealth
        self.entityManager = entityManager
        super.init()
    }

    override func update(deltaTime: TimeInterval) {
        if self.currentHealth <= 0 {
            guard let entity = entity,
                  let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
                return
            }
            // Need to remove the entity entirely if the health goes to zero or less
            self.entityManager.removeEntity(with: entity.id)
        }
    }

    func decreaseHealth(amount: CGFloat) {
        self.currentHealth -= amount
    }

    func increaseHealth(amount: CGFloat) {
        self.currentHealth = min(self.currentHealth + amount, self.maxHealth)
    }

    func restoreHealth() {
        self.currentHealth = maxHealth
    }
}
