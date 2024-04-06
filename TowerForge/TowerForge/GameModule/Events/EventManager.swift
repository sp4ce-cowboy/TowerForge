//
//  EventManager.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class EventManager {
    typealias EventHandler = (TFEvent) -> Void
    var eventTransformations: [any EventTransformation]
    var eventQueue: [TFEvent]
    var eventHandler: [TFEventTypeWrapper: [EventHandler]]
    private(set) var remoteEventManager: RemoteEventManager?
    private(set) var currentPlayer: GamePlayer?

    init(roomId: RoomId? = nil, currentPlayer: GamePlayer?) {
        eventTransformations = []
        eventQueue = []
        eventHandler = [:]

        if let roomId = roomId, let currentPlayer = currentPlayer {
            let publisher = FirebaseRemoteEventPublisher(roomId: roomId)
            let subscriber = FirebaseRemoteEventSubscriber(roomId: roomId, eventManager: self)
            self.remoteEventManager = RemoteEventManager(publisher: publisher, subscriber: subscriber)
            self.currentPlayer = currentPlayer
        }
    }

    func add(_ event: TFEvent) {
        eventQueue.append(event)
    }

    func add(_ event: TFRemoteEvent) {
        guard let remoteEventManager = remoteEventManager else {
            return event.unpack(into: self, for: event.source) // Unpack for self
        }
        remoteEventManager.publisher.publish(remoteEvent: event)
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

    func addTransformation(eventTransformation: any EventTransformation) {
        self.eventTransformations.append(eventTransformation)
    }

    func removeTransformation(eventTransformation: any EventTransformation) {
        self.eventTransformations.removeAll(where: { $0.id == eventTransformation.id })
    }

    func executeEvents(in target: EventTarget) {
        while !eventQueue.isEmpty {
            var currentEvent = eventQueue.removeFirst()

            for eventTransformation in eventTransformations {
                if let concurrentEvent = currentEvent as? ConcurrentEvent {
                    currentEvent = concurrentEvent.transform(eventTransformation: eventTransformation)
                } else {
                    currentEvent = eventTransformation.transformEvent(event: currentEvent)
                }
            }

            let output = currentEvent.execute(in: target)
            output.events.forEach { eventQueue.append($0) }

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
