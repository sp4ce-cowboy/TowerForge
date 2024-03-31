//
//  PowerUpFactory.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import Foundation

class PowerUpDelegateFactory {

    static func createPowerUpDelegate(type: PowerUp, eventManager: EventManager) -> PowerUpNodeDelegate {
        switch type {
        case .invulnerability:
            return InvulnerabilityPowerUpDelegate(eventManager: eventManager)
        }
    }
}
