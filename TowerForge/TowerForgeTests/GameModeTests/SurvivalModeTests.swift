//
//  SurvivalModeTests.swift
//  TowerForgeTests
//
//  Created by Vanessa Mae on 10/04/24.
//

import XCTest
@testable import TowerForge

class SurvivalModeTests: XCTestCase {

    func testUpdateGame_WaveGeneration() {
        // Setup
        let eventManager = EventManager()
        let maxLevel = 1
        let survivalGameMode = SurvivalGameMode(eventManager: eventManager, maxLevel: maxLevel)

        survivalGameMode.updateGame(deltaTime: SurvivalGameMode.WAVE_TIME_INTERVAL)

        XCTAssertEqual(survivalGameMode.gameState, .WIN, "Next wave should have been generated")
    }

    func testUpdateGame_GameState() {
        // Setup
        let eventManager = EventManager()
        let maxLevel = 1
        let survivalGameMode = SurvivalGameMode(eventManager: eventManager, maxLevel: maxLevel)

        XCTAssertEqual(survivalGameMode.gameState, GameState.PLAYING, "Game state should be PLAYING")
    }

    func testGetGameResults() {
        // Setup
        let eventManager = EventManager()
        let maxLevel = 1
        let survivalGameMode = SurvivalGameMode(eventManager: eventManager, maxLevel: maxLevel)

        survivalGameMode.updateGame(deltaTime: SurvivalGameMode.WAVE_TIME_INTERVAL)
        let results = survivalGameMode.getGameResults()

        XCTAssertEqual(results.count, 1, "Expected one game result")
        XCTAssertEqual(results[0].variable, "Finished Waves", "Expected variable name to be 'Finished Waves'")
        XCTAssertEqual(results[0].value, "1", "Expected value to be '1'")
    }
}
