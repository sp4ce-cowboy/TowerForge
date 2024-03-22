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
    unowned var sceneManagerDelegate: SceneManagerDelegate?

    override func sceneDidLoad() {
        super.sceneDidLoad()
        physicsWorld.contactDelegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        updateDelegate?.touch(at: location)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdatedTimeInterval == TimeInterval(0) {
            lastUpdatedTimeInterval = currentTime
        }

        let changeInTime = currentTime - lastUpdatedTimeInterval
        lastUpdatedTimeInterval = currentTime
        updateDelegate?.update(deltaTime: changeInTime)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? TFAnimatableNode,
              let nodeB = contact.bodyB.node as? TFAnimatableNode else {
            return
        }
        updateDelegate?.contactBegin(between: nodeA, and: nodeB)
    }

    public func didEnd(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? TFAnimatableNode,
              let nodeB = contact.bodyB.node as? TFAnimatableNode else {
            return
        }

        updateDelegate?.contactEnd(between: nodeA, and: nodeB)
    }
}
