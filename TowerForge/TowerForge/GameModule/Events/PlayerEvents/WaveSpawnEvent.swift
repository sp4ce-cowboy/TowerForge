//
//  RequestSpawnEvent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 23/3/24.
//

import Foundation

struct WaveSpawnEvent: TFEvent {
    let timestamp: TimeInterval
    let position: CGPoint
    let entityType: (PlayerSpawnable & TFEntity).Type
    let player: Player

    init<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, timestamp: TimeInterval,
                                        position: CGPoint, player: Player) {
        self.timestamp = timestamp
        self.position = position
        self.entityType = type
        self.player = player
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let homeSystem = target.system(ofType: HomeSystem.self) {
            homeSystem.waveSpawn(at: position, ofType: entityType, for: player)
        }
        return EventOutput()
    }
}
