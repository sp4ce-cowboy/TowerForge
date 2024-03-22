//
//  HealthComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 15/03/24.
//

import Foundation

class HealthComponent: TFComponent {
    override var componentType: Enums.Components { .Health }
    var currentHealth: CGFloat
    var maxHealth: CGFloat
    private var entityManager: EntityManager

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

    /// Restores health to the maximum possible value
    func restoreHealth() {
        self.currentHealth = maxHealth
    }

    /// Adjusts health by the specified amount.
    func adjustHealth(amount: CGFloat) {
        if amount < 0 {
            decreaseHealth(amount: abs(amount))
        } else {
            increaseHealth(amount: amount)
        }
    }

    /// Decreases currentHealth by the specified amount with a floor of 0.
    private func decreaseHealth(amount: CGFloat) {
        self.currentHealth = max(self.currentHealth - amount, 0)
    }

    /// Increases currentHealth by the specific amount with a ceiling of maxHealth
    private func increaseHealth(amount: CGFloat) {
        self.currentHealth = min(self.currentHealth + amount, self.maxHealth)
    }
}
