//
//  GameModeFactory.swift
//  TowerForge
//
//  Created by MacBook Pro on 27/03/24.
//

import Foundation

class GameModeFactory {
    enum Mode {
        case deathMatch
        case captureTheFlag
    }

    static func createGameMode(mode: Mode, eventManager: EventManager) -> GameMode {
        switch mode {
        case .captureTheFlag:
            return CaptureTheFlagMode(initialLife: 5, eventManager: eventManager)
        case .deathMatch:
            return DeathMatchMode(eventManager: eventManager)
        }
    }
}
