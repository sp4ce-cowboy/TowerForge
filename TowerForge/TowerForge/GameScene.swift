//
//  GameScene.swift
//  TowerForge
//
//  Created by MacBook Pro on 14/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        let textureNames = ["melee-1", "melee-2"]
        
        let entityManager = EntityManager()
        let meleeUnit = MeleeUnit(position: CGPoint(x: 100, y: 100), entityManager: entityManager, attackRate: 1.0, velocity: CGVector(dx: 1.0, dy: 0.0))
        entityManager.addEntity(meleeUnit)
        
        guard let sprite = meleeUnit.components(ofType: SpriteComponent.self) else {
            return
        }
        addChild(sprite.node)
        animatableNode.playAnimation()
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
