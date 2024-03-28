//
//  DeathMatchMode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class DeathMatchMode: GameMode {
    var modeName: String = "Death Match Mode"
    var modeDescription: String = "Kill as many units within the time limit"
    var gameProps: [GameProp] = [LifeProp(initialLife: 5), PointProp(initialPoint: 0) ]
    var gameState = GameState.IDLE

    func startGame() {

    }

    func resumeGame() {

    }

    func pauseGame() {

    }

    func winGame() {

    }

    func endGame() {

    }

}
