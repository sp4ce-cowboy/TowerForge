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
        var eventOutput1 = event1.execute(in: target)
        let eventOutput2 = event2.execute(in: target)
        eventOutput1.combine(with: eventOutput2)
        return eventOutput1
    }

    func transform(eventTransformation: EventTransformation) -> TFEvent {
        var transform1: TFEvent
        var transform2: TFEvent

        if let concurrentEvent1 = event1 as? ConcurrentEvent {
            transform1 = concurrentEvent1.transform(eventTransformation: eventTransformation)
        } else {
            transform1 = eventTransformation.transformEvent(event: event1)
        }

        if let concurrentEvent2 = event2 as? ConcurrentEvent {
            transform2 = concurrentEvent2.transform(eventTransformation: eventTransformation)
        } else {
            transform2 = eventTransformation.transformEvent(event: event2)
        }

        return ConcurrentEvent(transform1, transform2)
    }
}
