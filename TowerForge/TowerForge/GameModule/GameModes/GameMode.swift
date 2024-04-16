//
//  GameMode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

protocol GameResult {
    var variable: String { get  }
    var value: String { get }
}

enum Sorting {
    case decreasing
    case increasing
}

struct LeaderboardResult: GameResult {
    var variable: RankType.RawValue
    var value: String
    var sortingRule: Sorting
}

struct LocalResult: GameResult {
    var variable: String
    var value: String
}

protocol GameMode {
    var modeName: String { get }
    static var modeDescription: String { get }
    var gameProps: [any GameProp] { get }
    var gameState: GameState { get }
    var eventManager: EventManager { get }
    func updateGame(deltaTime: TimeInterval)
    func getGameResults() -> [GameResult]
    func concede(player: Player)
}
