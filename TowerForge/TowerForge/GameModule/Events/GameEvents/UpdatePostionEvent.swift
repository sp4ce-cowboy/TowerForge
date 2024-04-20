//
//  UpdatePostionEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 19/4/24.
//

import Foundation

struct UpdatePostionEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let position: CGPoint

    init(at timestamp: TimeInterval, entityId: UUID, position: CGPoint) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.position = position
    }

    func execute(in target: any EventTarget) -> EventOutput {
        if let movementSystem = target.system(ofType: MovementSystem.self) {
            movementSystem.updatePosition(for: entityId, to: position)
        }
        return EventOutput()
    }
}
