//
//  DeathMatchMode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class DeathMatchMode: GameMode {

    static var modeDescription: String = "Kill as many units within the time limit"
    static let DEATH_MATCH_MODE_TIMER = TimeInterval(120)

    var eventManager: EventManager
    var modeName: String = "Death Match Mode"
    var gameProps: [any GameProp] = [DeathProp(position: PositionConstants.DEATH_MATCH_POINT_OWN,
                                               player: .ownPlayer),
                                     DeathProp(position: PositionConstants.DEATH_MATCH_POINT_OPP,
                                               player: .oppositePlayer),
                                     PointProp(initialPoint: 0)]
    var timer = TimerProp(timeLength: DeathMatchMode.DEATH_MATCH_MODE_TIMER)
    var gameState = GameState.IDLE
    var currentOwnKillCounter: Int
    var currentOpponentKillCounter: Int
    var remainingTime: TimeInterval

    init(eventManager: EventManager) {
        self.currentOwnKillCounter = 0
        self.currentOpponentKillCounter = 0
        self.eventManager = eventManager
        self.gameProps.append(timer)
        self.gameState = .PLAYING
        self.remainingTime = timer.time
        eventManager.registerHandler(forEvent: KillEvent.self) { event in
            if let killEvent = event as? KillEvent {
                // Check if the event reduces life
                if killEvent.player == .ownPlayer {
                    self.currentOpponentKillCounter += 1
                } else if killEvent.player == .oppositePlayer {
                    self.currentOwnKillCounter += 1
                }
            }
        }
    }
    func updateGame(deltaTime: TimeInterval) {
        self.remainingTime = timer.time
        guard gameState != .LOSE else {
            return
        }
        guard remainingTime <= 0 else {
            return
        }
        if currentOwnKillCounter > currentOpponentKillCounter {
            gameState = .WIN
        } else if currentOwnKillCounter < currentOpponentKillCounter {
            gameState = .LOSE
        } else {
            gameState = .DRAW
        }
    }
    func getGameResults() -> [GameResult] {
        let result: [GameResult] = [
            LeaderboardResult(variable: RankType.TotalKill.rawValue,
                              value: String(self.currentOwnKillCounter),
                              sortingRule: .decreasing),
            LocalResult(variable: "Opponent Kill",
                        value: String(self.currentOpponentKillCounter))
        ]
        return result
    }

    func concede(player: Player) {
        self.gameState = player == .ownPlayer ? .LOSE : .WIN
    }
}
