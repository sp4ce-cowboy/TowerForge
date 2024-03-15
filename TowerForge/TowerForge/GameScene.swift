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
        let tfTextures = TFTextures(textureNames: textureNames, textureAtlasName: "Sprites", mainTextureName: "melee-1")
        let animatableNode = TFAnimatableNode(textures: tfTextures, height: 300, width: 300, animatableKey: "melee")
        addChild(animatableNode)
        animatableNode.playAnimation()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
