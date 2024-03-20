//
//  GameScene.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var lastUpdatedTimeInterval = TimeInterval(0)
    unowned var updateDelegate: SceneUpdateDelegate?

    override func update(_ currentTime: TimeInterval) {
        if lastUpdatedTimeInterval == TimeInterval(0) {
            lastUpdatedTimeInterval = currentTime
        }

        let changeInTime = currentTime - lastUpdatedTimeInterval
        lastUpdatedTimeInterval = currentTime
        updateDelegate?.update(deltaTime: changeInTime)
    }
}
