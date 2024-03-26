//
//  EventOutput.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

// Holds additional events generated from handling an event
struct EventOutput {
    var events: [TFEvent]

    init() {
        events = []
    }

    mutating func add(_ event: TFEvent) {
        events.append(event)
    }
}

extension EventOutput {
    mutating func combine(with otherEventOuput: EventOutput?) {
        self.events.append(contentsOf: otherEventOuput?.events ?? [])
    }
}
