//
//  DisabledEvent.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import Foundation

struct DisabledEvent: TFEvent {
    let timestamp: TimeInterval

    init(at timestamp: TimeInterval = .zero) {
        self.timestamp = timestamp
    }

    func execute(in target: any EventTarget) -> EventOutput {
        EventOutput()
    }
}
