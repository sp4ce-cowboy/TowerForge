//
//  GameEngineTests.swift
//  TowerForgeTests
//
//  Created by Rubesh on 25/3/24.
//

import XCTest
@testable import TowerForge

final class GameEngineTests: XCTestCase {

    func test_initializeGameEngine() {
        let emptyEntityManager = EntityManager()
        let emptySystemManager = SystemManager()
        let emptyEventManager = EventManager()

        // After adding team components (2)
        let entityCount = emptyEntityManager.entities.count + 2

        // Add default game count
        let eventCount = emptyEventManager.eventQueue.count + 1

        let gameEngine = GameEngine()

        XCTAssertEqual(gameEngine.entities.count,
                       entityCount,
                       "The GameEngine's entity manager must contain 2 entities on init, 1 team entity for each player")

        XCTAssertEqual(gameEngine.systemManager.systems.count,
                       emptySystemManager.systems.count,
                       "The GameEngine's system manager must have the same count as the empty system manager")

        XCTAssertEqual(gameEngine.eventManager.eventQueue.count,
                       eventCount,
                       "The GameEngine's event manager must have the same count as the empty event manager")
    }

}
