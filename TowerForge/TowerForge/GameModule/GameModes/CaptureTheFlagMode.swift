//
//  CaptureTheFlagMode.swift
//  TowerForge
//
//  Created by MacBook Pro on 27/03/24.
//

import Foundation

class CaptureTheFlagMode: GameMode {
    var eventManager: EventManager
    static let INITIAL_POINT = 5

    var modeName: String = "Capture The Flag"
    var modeDescription: String = "Destroy the enemy base!"
    var gameProps: [GameProp] = [PointProp(initialPoint: 0)]
    var gameState = GameState.IDLE
    var currentOwnLife: Int
    var currentOpponentLife: Int

    init(initialLife: Int, eventManager: EventManager) {
        self.gameProps.append(LifeProp(initialLife: initialLife))
        self.currentOwnLife = initialLife
        self.currentOpponentLife = initialLife
        self.eventManager = eventManager
        eventManager.registerHandler(forEvent: LifeEvent.self) { event in
            if let lifeEvent = event as? LifeEvent {
                // Check if the event reduces life
                if lifeEvent.player == .oppositePlayer && lifeEvent.lifeDecrease > 0 {
                    self.currentOpponentLife -= lifeEvent.lifeDecrease
                    print("Life reduced by \(lifeEvent.lifeDecrease). Current life: \(self.currentOwnLife)")
                } else if lifeEvent.player == .ownPlayer && lifeEvent.lifeDecrease > 0 {
                    self.currentOwnLife -= lifeEvent.lifeDecrease
                    print("Life reduced by \(lifeEvent.lifeDecrease). Current life: \(self.currentOwnLife)")
                }
            }
        }
    }
    func updateGame() {
        if self.currentOwnLife <= 0 {
            gameState = .LOSE
        } else if self.currentOpponentLife <= 0 {
            gameState = .WIN
        }
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

}
