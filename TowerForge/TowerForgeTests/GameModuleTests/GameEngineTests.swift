//
//  GameEngineTests.swift
//  TowerForgeTests
//
//  Created by Rubesh on 25/3/24.
//

import XCTest
@testable import TowerForge

final class GameEngineTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_initializeGameEngine() {
        let emptyEntityManager = EntityManager()
        let emptySystemManager = SystemManager()
        let emptyEventManager = EventManager()

        // After adding the playerInfo and team components (2 each)
        let entityCount = emptyEntityManager.entities.count + 4

        let gameEngine = GameEngine()

        XCTAssertEqual(gameEngine.entities.count,
                       entityCount,
                       "The GameEngine's entity manager must have the same count as the empty entity manager")

        XCTAssertEqual(gameEngine.systemManager.systems.count,
                       emptySystemManager.systems.count,
                       "The GameEngine's system manager must have the same count as the empty system manager")

        XCTAssertEqual(gameEngine.eventManager.eventQueue.count,
                       emptyEventManager.eventQueue.count,
                       "The GameEngine's event manager must have the same count as the empty event manager")
    }

}
