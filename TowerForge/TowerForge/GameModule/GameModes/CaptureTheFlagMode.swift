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
    var currentLife: Int

    init(initialLife: Int, eventManager: EventManager) {
        self.gameProps.append(LifeProp(initialLife: initialLife))
        self.currentLife = initialLife
        self.eventManager = eventManager
        eventManager.registerHandler(forEvent: LifeEvent.self) { event in
            if let lifeEvent = event as? LifeEvent {
                // Check if the event reduces life
                if lifeEvent.lifeDecrease > 0 {
                    self.currentLife -= lifeEvent.lifeDecrease
                    print("Life reduced by \(lifeEvent.lifeDecrease). Current life: \(self.currentLife)")
                }
            }
        }
    }
    func updateGame() {
        if self.currentLife < 0 {
            gameState = .LOSE
        } else {
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
