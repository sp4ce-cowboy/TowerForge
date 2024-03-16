//
//  MoveEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

struct MoveEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let displacement: CGVector

    init(on entityId: UUID, at timestamp: TimeInterval, with displacement: CGVector) {
        self.entityId = entityId
        self.timestamp = timestamp
        self.displacement = displacement
    }

    func execute(in target: any EventTarget) -> EventOutput {
        target.system(ofType: MovementSystem.self) // TODO: Handle Move Event
        return EventOutput()
    }
}
