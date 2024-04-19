//
//  NoCostPowerUpDelegate.swift
//  TowerForge
//
//  Created by Keith Gan on 19/4/24.
//

import Foundation

class NoCostPowerUpDelegate: PowerUpNodeDelegate {
    let eventManager: EventManager

    init(eventManager: EventManager) {
        self.eventManager = eventManager
    }

    func powerUpNodeDidSelect() {
        let noCostPowerUp = NoCostPowerUp()
        eventManager.addTransformation(eventTransformation: noCostPowerUp)

        DispatchQueue.main.asyncAfter(deadline: .now() + noCostPowerUp.DURATION) {
            self.eventManager.removeTransformation(eventTransformation: noCostPowerUp)
        }
    }
}
