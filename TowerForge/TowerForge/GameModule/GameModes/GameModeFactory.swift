//
//  GameModeFactory.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

enum Mode {
    case deathMatch
    case captureTheFlag
}

class GameModeFactory {

    static func createGameMode(mode: Mode, eventManager: EventManager) -> GameMode {
        switch mode {
        case .captureTheFlag:
            return CaptureTheFlagMode(initialLife: 5, eventManager: eventManager)
        case .deathMatch:
            return DeathMatchMode(eventManager: eventManager)
        }
    }
}
