//
//  HealthComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 15/03/24.
//

import SpriteKit

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
        updateHealthMeter()
    }

    /// Increases currentHealth by the specific amount with a ceiling of maxHealth
    func increaseHealth(amount: CGFloat) {
        self.currentHealth = min(self.currentHealth + amount, self.maxHealth)
        updateHealthMeter()
    }

    func restoreHealth() {
        self.currentHealth = maxHealth
    }
    override func didAddToEntity(_ entity: TFEntity) {
        super.didAddToEntity(entity)
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        let healthMeterNode = SKSpriteNode(color: .green, size: CGSize(width: 100, height: 10))
        healthMeterNode.anchorPoint = CGPoint(x: 0, y: 0)
        healthMeterNode.position = CGPoint(x: 0 - spriteComponent.node.width / 2, y: spriteComponent.node.height / 2)
        healthMeterNode.name = "healthMeterNode"
        spriteComponent.node.addChild(healthMeterNode)
    }
    func updateHealthMeter() {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
              let healthMeterNode = spriteComponent.node.childNode(withName: "healthMeterNode") else {
            return
        }
        let healthPercentage = currentHealth / maxHealth
        healthMeterNode.xScale = healthPercentage
    }
}
