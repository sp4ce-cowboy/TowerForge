//
//  EventManager.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class EventManager {
    typealias EventHandler = (TFEvent) -> Void
    var eventTransformations: [UUID: any EventTransformation]
    var eventQueue: [TFEvent]
    var eventHandler: [TFEventTypeWrapper: [EventHandler]]
    private(set) var remoteEventManager: RemoteEventManager?
    private(set) var currentPlayer: GamePlayer?
    private(set) var isHost = true

    init(roomId: RoomId? = nil, isHost: Bool = true, currentPlayer: GamePlayer? = nil) {
        eventTransformations = [:]
        eventQueue = []
        eventHandler = [:]

        if let roomId = roomId, let currentPlayer = currentPlayer {
            let publisher = FirebaseRemoteEventPublisher(roomId: roomId)
            let subscriber = FirebaseRemoteEventSubscriber(roomId: roomId, eventManager: self)
            self.remoteEventManager = RemoteEventManager(publisher: publisher, subscriber: subscriber)
            self.currentPlayer = currentPlayer
            self.isHost = isHost
        }
    }

    func add(_ event: TFEvent) {
        eventQueue.append(event)
    }

    func add(_ event: TFRemoteEvent) {
        guard let remoteEventManager = remoteEventManager else {
            return event.unpack(into: self, for: event.source) // Unpack for self
        }

        DispatchQueue.global().async {
            remoteEventManager.publisher.publish(remoteEvent: event)
        }
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
        self.eventTransformations[eventTransformation.id] = eventTransformation
    }

    func removeTransformation(with id: UUID) {
        self.eventTransformations.removeValue(forKey: id)
    }

    func executeEvents(in target: EventTarget) {
        var newEvents: [TFEvent] = []
        let numEvents = eventQueue.count
        for event in eventQueue {
            let currentEvent = transform(event: event)
            let output = currentEvent.execute(in: target)
            newEvents.append(contentsOf: output.events)

            updateHandlers(event: currentEvent)
        }
        eventQueue.removeFirst(numEvents)
        eventQueue.append(contentsOf: newEvents)
    }

    private func transform(event: TFEvent) -> TFEvent {
        var currentEvent = event
        for eventTransformation in eventTransformations.values {
            if let concurrentEvent = currentEvent as? ConcurrentEvent {
                currentEvent = concurrentEvent.transform(eventTransformation: eventTransformation)
            } else {
                currentEvent = eventTransformation.transformEvent(event: currentEvent)
            }
        }
        return currentEvent
    }

    private func updateHandlers(event: TFEvent) {
        // Get the type of the current event
        let eventTypeWrapper = TFEventTypeWrapper(type: type(of: event))

        // Check if there are any handlers registered for this event type
        if let handlers = eventHandler[eventTypeWrapper] {
            // Execute each handler with the current event
            for handler in handlers {
                handler(event)
            }
        }
    }
}
