//
//  EventManager.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class EventManager {
    var eventQueue: [TFEvent]

    init() {
        eventQueue = []
    }

    func add(_ event: TFEvent) {
        eventQueue.append(event)
    }

    func executeEvents(in target: EventTarget) {
        while !eventQueue.isEmpty {
            let currentEvent = eventQueue.removeFirst()
            if let output = currentEvent.execute(in: target) {
                output.events.forEach { eventQueue.append($0) }
            }
        }
    }
}
