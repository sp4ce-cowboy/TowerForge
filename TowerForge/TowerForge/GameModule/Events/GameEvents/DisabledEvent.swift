//
//  DisabledEvent.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import Foundation

struct DisabledEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID

    init(on entityId: UUID = UUID(), at timestamp: TimeInterval = .zero) {
        self.entityId = entityId
        self.timestamp = timestamp
    }

    func execute(in target: any EventTarget) -> EventOutput {
        EventOutput()
    }
}
