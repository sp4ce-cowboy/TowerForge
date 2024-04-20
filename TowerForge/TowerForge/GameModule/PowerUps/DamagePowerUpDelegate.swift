//
//  DamagePowerUpDelegate.swift
//  TowerForge
//
//  Created by Keith Gan on 19/4/24.
//

import Foundation

class DamagePowerUpDelegate: PowerUpNodeDelegate {
    let eventManager: EventManager

    init(eventManager: EventManager) {
        self.eventManager = eventManager
    }

    func powerUpNodeDidSelect() {
        let damagePowerUp = DamagePowerUp()
        eventManager.addTransformation(eventTransformation: damagePowerUp)

        DispatchQueue.main.asyncAfter(deadline: .now() + damagePowerUp.DURATION) {
            self.eventManager.removeTransformation(eventTransformation: damagePowerUp)
        }
    }
}
