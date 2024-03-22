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
    var isZero: Bool {
        currentHealth.isZero
    }

    init(maxHealth: CGFloat) {
        self.currentHealth = maxHealth
        self.maxHealth = maxHealth
        super.init()
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
    func decreaseHealth(amount: CGFloat) {
        self.currentHealth = max(self.currentHealth - amount, 0)
    }

    /// Increases currentHealth by the specific amount with a ceiling of maxHealth
    func increaseHealth(amount: CGFloat) {
        self.currentHealth = min(self.currentHealth + amount, self.maxHealth)
    }

    func restoreHealth() {
        self.currentHealth = maxHealth
    }
}
