//
//  SpawnEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

struct SpawnEvent<T: TFEntity>: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID

    private let position: CGPoint
    private let velocity: CGVector

    init(timestamp: TimeInterval, entityId: UUID, position: CGPoint, velocity: CGVector) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.position = position
        self.velocity = velocity
    }

    func execute(in target: any EventTarget) -> EventOutput {
        target.system(ofType: SpawnSystem.self) // TODO: Handle Spawn Event
        return EventOutput()
    }
}
