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
    case survivalLevelOne
    case survivalLevelTwo
    case survivalLevelThree
}

class GameModeFactory {
    static func createGameMode(mode: Mode, eventManager: EventManager) -> GameMode {
        switch mode {
        case .captureTheFlag:
            return CaptureTheFlagMode(initialLife: 5, eventManager: eventManager)
        case .deathMatch:
            return DeathMatchMode(eventManager: eventManager)
        case .survivalLevelOne:
            return SurvivalGameMode(eventManager: eventManager, maxLevel: 1)
        case .survivalLevelTwo:
            return SurvivalGameMode(eventManager: eventManager, maxLevel: 2)
        case .survivalLevelThree:
            return SurvivalGameMode(eventManager: eventManager, maxLevel: 3)
        }
    }
}
