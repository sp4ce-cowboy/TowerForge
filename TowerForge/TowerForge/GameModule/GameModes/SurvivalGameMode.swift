//
//  SurvivalGameMode.swift
//  TowerForge
//
//  Created by MacBook Pro on 09/04/24.
//

import Foundation
import UIKit

class SurvivalGameMode: GameMode {
    var modeName: String = "Survival Game Mode"

    var modeDescription: String = "Don't let the enemy invade your base!"

    var gameProps: [any GameProp] = [PointProp(initialPoint: 0)]

    var gameState = GameState.IDLE

    var eventManager: EventManager

    private var currentOwnLife = 1

    private var currentLevel: Int = 1
    private var maxLevel: Int

    private var nextWaveTime = TimeInterval(10)
    private var waveTimeInterval = TimeInterval(100)

    init(eventManager: EventManager, maxLevel: Int) {
        self.eventManager = eventManager
        self.maxLevel = maxLevel

        eventManager.registerHandler(forEvent: LifeEvent.self) { event in
            if let lifeEvent = event as? LifeEvent {
                // Check if the event reduces life
                if  lifeEvent.player == .oppositePlayer && lifeEvent.lifeDecrease > 0 {
                    self.currentOwnLife -= lifeEvent.lifeDecrease
                }
            }
        }
    }

    func updateGame(deltaTime: TimeInterval) {
        nextWaveTime -= deltaTime
        if nextWaveTime < 0 && self.currentLevel <= self.maxLevel {
            nextWaveTime = waveTimeInterval
            self.currentLevel += 1
            self.generateWaveSpawns(enemyCount: 10 * self.currentLevel)
        }
        if self.currentLevel > self.maxLevel {
            gameState = .WIN
        }
        if self.currentOwnLife <= 0 {
            gameState = .LOSE
        }
    }

    func startGame() {
        //
    }

    private func generateWaveSpawns(enemyCount: Int) {
        for _ in 0..<enemyCount {
            let randPosition = getRandomPosition()
            guard let unit = SpawnableEntities.playerSpawnableEntities.randomElement() else {
                continue
            }
            self.eventManager.add(WaveSpawnEvent(ofType: unit,
                                             timestamp: CACurrentMediaTime(),
                                             position: randPosition,
                                             player: .oppositePlayer))
            AudioManager.shared.playSpecialEffect()
        }
    }

    private func getRandomPosition() -> CGPoint {
        let randomY = CGFloat.random(in: 200...UIScreen.main.bounds.height)
        // TODO: Change the GameWorld to a constant
        return CGPoint(x: GameWorld.worldSize.width, y: randomY)

    }

}
