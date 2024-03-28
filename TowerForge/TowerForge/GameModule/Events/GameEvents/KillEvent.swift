//
//  KillEvent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

struct KillEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let player: Player

    init(on entityId: UUID, at timestamp: TimeInterval, player: Player) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.player = player
    }

    func execute(in target: any EventTarget) -> EventOutput? {
        guard let removeSystem = target.system(ofType: RemoveSystem.self) else {
            return nil
        }

        removeSystem.handleRemove(for: entityId)

        guard let homeSystem = target.system(ofType: HomeSystem.self) else {
            return nil
        }
        homeSystem.changeDeathCount(for: player, change: 1)
        return nil
    }
}
