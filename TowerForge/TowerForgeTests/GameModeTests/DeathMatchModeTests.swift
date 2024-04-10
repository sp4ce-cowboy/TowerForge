//
//  DeathMatchModeTests.swift
//  TowerForgeTests
//
//  Created by Vanessa Mae on 10/04/24.
//

import XCTest
@testable import TowerForge

class DeathMatchModeTests: XCTestCase {

    func testInitialization() {
        let eventManager = EventManager()

        let deathMatchMode = DeathMatchMode(eventManager: eventManager)

        XCTAssertNotNil(deathMatchMode, "DeathMatchMode should not be nil")
        XCTAssertEqual(deathMatchMode.modeName, "Death Match Mode", "Expected mode name to be 'Death Match Mode'")
        XCTAssertEqual(deathMatchMode.gameProps.count, 4, "Expected 3 game props")
    }

    func testStateGame() {

        let eventManager = EventManager()
        let deathMatchMode = DeathMatchMode(eventManager: eventManager)
        deathMatchMode.currentOwnKillCounter = 3
        deathMatchMode.currentOpponentKillCounter = 5

        XCTAssertEqual(deathMatchMode.gameState, GameState.PLAYING, "Expected game state to be LOSE due to timeout")
    }

    func testGetGameResults() {

        let eventManager = EventManager()
        let deathMatchMode = DeathMatchMode(eventManager: eventManager)
        deathMatchMode.currentOwnKillCounter = 8
        deathMatchMode.currentOpponentKillCounter = 6

        let results = deathMatchMode.getGameResults()

        XCTAssertEqual(results.count, 2, "Expected two game results")
        XCTAssertEqual(results[0].value, "8", "Expected value to be '8'")
        XCTAssertEqual(results[1].value, "6", "Expected value to be '6'")
    }
}
