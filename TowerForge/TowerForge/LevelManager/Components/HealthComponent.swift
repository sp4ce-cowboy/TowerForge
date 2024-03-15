//
//  HealthComponent.swift
//  TowerForge
//
//  Created by MacBook Pro on 15/03/24.
//

import Foundation

class HealthComponent: TFComponent {
    public var currentHealth: CGFloat
    public var maxHealth: CGFloat

    init(maxHealth: CGFloat) {
        self.currentHealth = maxHealth
        self.maxHealth = maxHealth
        super.init()
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
