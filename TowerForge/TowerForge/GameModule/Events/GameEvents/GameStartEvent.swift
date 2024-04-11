//
//  GameStartEvent.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

struct GameStartEvent: TFEvent {
    let timestamp: TimeInterval = .zero
    let entityId = UUID()

    init() {
    }

    func execute(in target: any EventTarget) -> EventOutput {
        EventOutput()
    }
}
