//
//  ConcurrentEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

struct ConcurrentEvent: TFEvent {
    var timestamp: TimeInterval
    var entityId: UUID

    private let event1: TFEvent
    private let event2: TFEvent

    init(_ event1: TFEvent, _ event2: TFEvent) {
        self.timestamp = event1.timestamp
        self.entityId = event1.entityId
        self.event1 = event1
        self.event2 = event2
    }

    func execute(in target: any EventTarget) -> EventOutput {
        var eventOutput = event1.execute(in: target)
        let eventOutput2 = event2.execute(in: target)

        eventOutput.combine(with: eventOutput2)

        return eventOutput
    }
}
