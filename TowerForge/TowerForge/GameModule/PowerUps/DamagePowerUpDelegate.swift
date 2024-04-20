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
        let remoteEvent = RemotePowerupEvent(powerup: .Damage, player: .ownPlayer,
                                             source: eventManager.currentPlayer ?? .defaultPlayer)
        eventManager.add(remoteEvent)
    }
}
