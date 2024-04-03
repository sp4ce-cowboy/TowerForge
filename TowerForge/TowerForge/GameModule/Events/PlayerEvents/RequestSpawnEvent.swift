//
//  RequestSpawnEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import Foundation

struct RequestSpawnEvent: TFEvent {
    let timestamp: TimeInterval
    let position: CGPoint
    let entityType: (PlayerSpawnable & TFEntity).Type
    let player: Player

    /// TODO: might need to change this to something other than throwing fatal error,
    /// because it could cause accidental application crash, for example iterating through
    /// a collection of TFEvents.
    var entityId: UUID {
        fatalError("entityId is not to be used here")
    }

    init<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, timestamp: TimeInterval,
                                        position: CGPoint, player: Player) {
        self.timestamp = timestamp
        self.position = position
        self.entityType = type
        self.player = player
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let homeSystem = target.system(ofType: HomeSystem.self) {
            homeSystem.attemptSpawn(at: position, ofType: entityType, for: player)
        }
        return EventOutput()
    }
}
