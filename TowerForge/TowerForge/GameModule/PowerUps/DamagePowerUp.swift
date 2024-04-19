//
//  DamagePowerUp.swift
//  TowerForge
//
//  Created by Keith Gan on 19/4/24.
//

import Foundation

class DamagePowerUp: EventTransformation {
    let DURATION = CGFloat(5)
    let DAMAGE_SCALE = CGFloat(2)
    let id: UUID
    let player: Player

    required init(player: Player = .ownPlayer) {
        self.id = UUID()
        self.player = player
    }

    func transformEvent(event: TFEvent) -> TFEvent {
        guard let damageEvent = event as? DamageEvent, damageEvent.player == player else {
            return event
        }

        return DamageEvent(on: damageEvent.entityId, at: damageEvent.timestamp, with: damageEvent.damage * DAMAGE_SCALE,
                           player: damageEvent.player)
    }
}
