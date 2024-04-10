//
//  CaptureTheFlagMode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class CaptureTheFlagMode: GameMode {
    var eventManager: EventManager
    static let INITIAL_POINT = 5

    var modeName: String = "Capture The Flag"
    static var modeDescription: String = "Destroy the enemy base!"
    var gameProps: [any GameProp] = [PointProp(initialPoint: 0)]
    var gameState = GameState.IDLE
    var currentOwnLife: Int
    var currentOpponentLife: Int

    init(initialLife: Int, eventManager: EventManager) {
        self.gameProps.append(LifeProp(initialLife: initialLife,
                                       position: PositionConstants.CTF_POINT_OWN,
                                       player: .ownPlayer,
                                       size: SizeConstants.CTF_POINT_SIZE))
        self.gameProps.append(LifeProp(initialLife: initialLife,
                                       position: PositionConstants.CTF_POINT_OPP,
                                       player: .oppositePlayer,
                                       size: SizeConstants.CTF_POINT_SIZE))
        self.currentOwnLife = initialLife
        self.currentOpponentLife = initialLife
        self.eventManager = eventManager
        self.gameState = .PLAYING
        eventManager.registerHandler(forEvent: LifeEvent.self) { event in
            if let lifeEvent = event as? LifeEvent {
                // Check if the event reduces life
                if lifeEvent.player == .ownPlayer && lifeEvent.lifeDecrease > 0 {
                    self.currentOpponentLife -= lifeEvent.lifeDecrease
                } else if lifeEvent.player == .oppositePlayer && lifeEvent.lifeDecrease > 0 {
                    self.currentOwnLife -= lifeEvent.lifeDecrease
                }
            }
        }
    }
    func updateGame(deltaTime: TimeInterval) {
        if self.currentOwnLife <= 0 {
            gameState = .LOSE
        } else if self.currentOpponentLife <= 0 {
            gameState = .WIN
        }
    }
    func getGameResults() -> [GameResult] {
        [GameResult(variable: "Life left", value: String(self.currentOwnLife))]
    }
}
