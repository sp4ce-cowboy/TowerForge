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
        case .Invulnerability:
            return InvulnerabilityPowerUpDelegate(eventManager: eventManager)
        case .Damage:
            return DamagePowerUpDelegate(eventManager: eventManager)
        case .NoCost:
            return NoCostPowerUpDelegate(eventManager: eventManager)
        }
    }
}
