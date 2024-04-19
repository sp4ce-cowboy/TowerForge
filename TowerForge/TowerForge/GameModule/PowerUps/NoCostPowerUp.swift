//
//  NoCostPowerUp.swift
//  TowerForge
//
//  Created by Keith Gan on 19/4/24.
//

import Foundation

class NoCostPowerUp: EventTransformation {
    let DURATION = CGFloat(3)
    let id: UUID
    let player: Player

    required init(player: Player = .ownPlayer) {
        self.id = UUID()
        self.player = player
    }

    func transformEvent(event: TFEvent) -> TFEvent {
        guard let requestSpawnEvent = event as? RequestSpawnEvent, requestSpawnEvent.player == player else {
            return event
        }

        return WaveSpawnEvent(ofType: requestSpawnEvent.entityType, timestamp: requestSpawnEvent.timestamp, position:
                                requestSpawnEvent.position, player: requestSpawnEvent.player)
    }
}
