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
//        let textureNames = ["melee-1", "melee-2"]
//        let tfTextures = TFTextures(textureNames: textureNames, textureAtlasName: "Sprites", mainTextureName: "melee-1")
//        let animatableNode = TFAnimatableNode(textures: tfTextures, height: 300, width: 300, animatableKey: "melee")
//        addChild(animatableNode)
//        animatableNode.playAnimation()
        
        let entityManager = EntityManager()
        let meleeUnit = MeleeUnit(position: CGPoint(x: 100, y: 100), entityManager: entityManager, attackRate: 1.0, velocity: CGVector(dx: 1.0, dy: 0.0))
        entityManager.add(meleeUnit)
        guard let sprite = meleeUnit.component(ofType: SpriteComponent.self) else {
            return
        }
        print(sprite.node)
        addChild(sprite.node)
        sprite.node.playAnimation()
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
