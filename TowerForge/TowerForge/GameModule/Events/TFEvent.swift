//
//  TFEvent.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

struct TFEventTypeWrapper {
    let type: TFEvent.Type
}

extension TFEventTypeWrapper: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }
}

extension TFEventTypeWrapper: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

protocol TFEvent {
    var timestamp: TimeInterval { get }
    var entityId: UUID { get }

    /// Execute method returns an optional EventOutput as not all event executions
    /// will return an EventOutput
    func execute(in target: EventTarget) -> EventOutput?
}

extension TFEvent {
    func concurrentlyWith(_ otherEvent: (TFEvent)?) -> TFEvent {
        guard let otherEvent = otherEvent else {
            return self
        }
        return ConcurrentEvent(self, otherEvent)
    }
}
