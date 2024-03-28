//
//  CaptureTheFlagMode.swift
//  TowerForge
//
//  Created by MacBook Pro on 27/03/24.
//

import Foundation

class CaptureTheFlagMode: GameMode {
    static let INITIAL_POINT = 5

    var modeName: String = "Capture The Flag"
    var modeDescription: String = "Destroy the enemy base!"
    var gameProps: [GameProp] = [PointProp(initialPoint: 0)]
    var gameState = GameState.IDLE
    var currentLife: Int

    init(initialLife: Int) {
        self.gameProps.append(LifeProp(initialLife: initialLife))
        self.currentLife = initialLife
    }

    func startGame() {
        gameState = GameState.PLAYING
    }

    func resumeGame() {
        gameState = GameState.PLAYING
    }

    func pauseGame() {
        gameState = GameState.PAUSED
    }

    func winGame() {
        gameState = GameState.WIN
    }

    func endGame() {
        gameState = GameState.QUIT
    }

}
