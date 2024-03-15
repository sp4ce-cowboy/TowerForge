//
//  HealthComponent.swift
//  TowerForge
//
//  Created by MacBook Pro on 15/03/24.
//

import Foundation

class HealthComponent: TFComponent {
    public var currentHealth: Float
    public var maxHealth: Float

    init(maxHealth: Float) {
        self.currentHealth = maxHealth
        self.maxHealth = maxHealth
        super.init()
    }
    
    func decreaseHealth(amount: Float) {
        self.currentHealth -= amount
    }
    
    func increaseHealth(amount: Float) {
        self.currentHealth = min(self.currentHealth + amount, self.maxHealth)
    }
    
    func restoreHealth() {
        self.currentHealth = maxHealth
    }
}
