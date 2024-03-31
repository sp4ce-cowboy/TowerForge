//
//  WizardUnit.swift
//  TowerForge
//
//  Created by Vanessa Mae on 31/03/24.
//

import Foundation

class WizardUnit: BaseUnit, PlayerSpawnable {
    static let title: String = "wizard"
    static let textureNames = ["Wizard-0", "Wizard-1", "Wizard-2"]
    static let size = CGSize(width: 100, height: 100)
    static let key = "shoot"
    static let maxHealth = 100.0
    static let damage = 10.0
    static var cost = 5
    static let attackRate = 1.0
    static let velocity = CGVector(dx: 30.0, dy: 0.0)
    static let range = 400.0
    static let attackPower = 10.0

    required init(position: CGPoint, player: Player) {
        super.init(textureNames: WizardUnit.textureNames,
                   size: WizardUnit.size,
                   key: WizardUnit.key,
                   position: position,
                   maxHealth: WizardUnit.maxHealth,
                   velocity: WizardUnit.velocity,
                   player: player)

        self.addComponent(ShootingComponent(fireRate: WizardUnit.attackRate,
                                            range: WizardUnit.range,
                                            attackPower: WizardUnit.attackPower, shootingType: WizardBall.self))
    }
}
