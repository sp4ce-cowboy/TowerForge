//
//  EventManager.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class EventManager {
    typealias EventHandler = (TFEvent) -> Void
    var eventQueue: [TFEvent]
    var eventHandler: [TFEventTypeWrapper: [EventHandler]]

    init() {
        eventQueue = []
        eventHandler = [:]
    }

    func add(_ event: TFEvent) {
        eventQueue.append(event)
    }

    func registerHandler<T: TFEvent>(forEvent eventType: T.Type, handler: @escaping EventHandler) {
        // Create a wrapper for the event type
        let eventTypeWrapper = TFEventTypeWrapper(type: eventType)

        // If there is already a handler registered for this event type, append to it
        if var handlers = eventHandler[eventTypeWrapper] {
            handlers.append(handler)
            eventHandler[eventTypeWrapper] = handlers
        } else {
            // Otherwise, create a new array with the handler and store it
            eventHandler[eventTypeWrapper] = [handler]
        }
    }

    func executeEvents(in target: EventTarget) {
        while !eventQueue.isEmpty {
            let currentEvent = eventQueue.removeFirst()
            if let output = currentEvent.execute(in: target) {
                output.events.forEach { eventQueue.append($0) }
            }
            // Get the type of the current event
            let eventTypeWrapper = TFEventTypeWrapper(type: type(of: currentEvent))

            // Check if there are any handlers registered for this event type
            if let handlers = eventHandler[eventTypeWrapper] {
                // Execute each handler with the current event
                for handler in handlers {
                    handler(currentEvent)
                }
            }
        }
    }
}
