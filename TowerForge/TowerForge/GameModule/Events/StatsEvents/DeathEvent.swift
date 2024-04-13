//
//  DeathEvent.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

struct DeathEvent: TFEvent {
    let timestamp: TimeInterval = .zero
    let entityId: UUID

    init(_ entityId: UUID) {
        self.entityId = entityId
    }

    func execute(in target: any EventTarget) -> EventOutput {
        EventOutput()
    }
}
