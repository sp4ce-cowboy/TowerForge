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

    func execute(in target: any EventTarget) -> EventOutput? {
        var eventOutput1 = event1.execute(in: target)
        let eventOutput2 = event2.execute(in: target)

        eventOutput1?.combine(with: eventOutput2)
        return eventOutput1 != nil ? eventOutput1 : eventOutput2
    }

    func transform(eventTransformation: EventTransformation) -> TFEvent {
        let transform1 = eventTransformation.transformEvent(event: event1)
        let transform2 = eventTransformation.transformEvent(event: event2)
        return ConcurrentEvent(transform1, transform2)
    }
}
