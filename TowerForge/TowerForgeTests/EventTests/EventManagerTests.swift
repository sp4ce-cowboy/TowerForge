//
//  EventManagerTests.swift
//  TowerForgeTests
//
//  Created by Zheng Ze on 7/4/24.
//

import XCTest
@testable import TowerForge

final class EventManagerTests: XCTestCase {
    func test_initialize() {
        let eventManager = EventManager()
        XCTAssertEqual(eventManager.eventQueue.count, 0)
        XCTAssertEqual(eventManager.eventTransformations.count, 0)
        XCTAssertEqual(eventManager.eventHandler.count, 0)
        XCTAssertNil(eventManager.remoteEventManager)
    }

    func test_intialiseWithNetworking() {
        let eventManager = EventManager(roomId: "testRoom",
                                        currentPlayer: GamePlayer(userPlayerId: "test", userName: "test"))
        XCTAssertEqual(eventManager.eventQueue.count, 0)
        XCTAssertEqual(eventManager.eventTransformations.count, 0)
        XCTAssertEqual(eventManager.eventHandler.count, 0)
        XCTAssertNotNil(eventManager.remoteEventManager)
    }

    func test_addEvents_eventsShouldGetAdded() {
        let eventManager = EventManager()
        XCTAssertEqual(eventManager.eventQueue.count, 0)

        let event = TestEvent()
        eventManager.add(event)

        XCTAssertEqual(eventManager.eventQueue.count, 1)
        XCTAssertIdentical(eventManager.eventQueue[0] as AnyObject, event)
    }

    func test_addEventTransformation_transformationAdded() {
        let eventManager = EventManager()
        XCTAssertEqual(eventManager.eventTransformations.count, 0)

        let eventTransformation = TestEventTransformation()
        eventManager.addTransformation(eventTransformation: eventTransformation)

        XCTAssertEqual(eventManager.eventTransformations.count, 1)
        XCTAssertIdentical(eventManager.eventTransformations[eventTransformation.id], eventTransformation)
    }

    func test_removeEventTransformation_transformationRemoved() {
        let eventManager = EventManager()
        XCTAssertEqual(eventManager.eventTransformations.count, 0)

        let eventTransformation = TestEventTransformation()
        eventManager.addTransformation(eventTransformation: eventTransformation)

        XCTAssertEqual(eventManager.eventTransformations.count, 1)
        XCTAssertIdentical(eventManager.eventTransformations[eventTransformation.id], eventTransformation)

        eventManager.removeTransformation(with: eventTransformation.id)

        XCTAssertEqual(eventManager.eventTransformations.count, 0)
    }

    func test_addRemoteEventWithoutNetworking_eventUnpackedImmediately() {
        let eventManager = EventManager()
        XCTAssertEqual(eventManager.eventQueue.count, 0)

        let event = TestRemoteEvent()
        eventManager.add(event)

        XCTAssertEqual(eventManager.eventQueue.count, 1)
        XCTAssertTrue(eventManager.eventQueue[0] is TestEvent)
    }

    func test_addRemoteEventWithNetworking_eventNotUnpackedImmediately() {
        let eventManager = EventManager(roomId: "testRoom",
                                        currentPlayer: GamePlayer(userPlayerId: "test", userName: "test"))
        XCTAssertEqual(eventManager.eventQueue.count, 0)

        let event = TestRemoteEvent()
        eventManager.add(event)

        XCTAssertEqual(eventManager.eventQueue.count, 0)
    }

    func test_executeEvents_eventsShouldGetExecuted() {
        let eventA = TestEvent()
        let eventB = TestEvent()
        let eventC = TestEvent()
        let eventManager = EventManager()

        eventManager.add(eventA)
        eventManager.add(eventB)
        eventManager.add(eventC)

        XCTAssertFalse(eventA.didExecute)
        XCTAssertFalse(eventB.didExecute)
        XCTAssertFalse(eventC.didExecute)

        eventManager.executeEvents(in: TestEventTarget())

        XCTAssertTrue(eventA.didExecute)
        XCTAssertTrue(eventB.didExecute)
        XCTAssertTrue(eventC.didExecute)
    }

    func test_executeEventWithTransformation_eventTransformed() {
        let event = TestEvent()
        let transformation = TestEventTransformation()
        let eventManager = EventManager()

        eventManager.addTransformation(eventTransformation: transformation)
        eventManager.add(event)

        XCTAssertFalse(transformation.didTransformEvent)

        eventManager.executeEvents(in: TestEventTarget())

        XCTAssertTrue(transformation.didTransformEvent)
    }
}
