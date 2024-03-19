//
//  GameScene.swift
//  TowerForge
//
//  Created by MacBook Pro on 14/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var lastUpdatedTimeInterval = TimeInterval(0)
    private var entityManager: EntityManager?

    override func didMove(to view: SKView) {
//        let textureNames = ["melee-1", "melee-2"]
//        let tfTextures = TFTextures(textureNames: 
//        textureNames, textureAtlasName: "Sprites", mainTextureName: "melee-1")
//        let animatableNode = TFAnimatableNode(textures: tfTextures, height: 300, width: 300, animatableKey: "melee")
//        addChild(animatableNode)
//        animatableNode.playAnimation()
        entityManager = EntityManager()
        guard let entityManager = entityManager else {
            return
        }

        let meleeUnit = MeleeUnit(position: CGPoint(x: 0, y: 100),
                                  entityManager: entityManager,
                                  attackRate: 1.0, velocity:
                                    CGVector(dx: 10.0, dy: 0.0))

        let soldierUnit = SoldierUnit(position: CGPoint(x: 0, y: 50),
                                      entityManager: entityManager,
                                      attackRate: 1.0,
                                      velocity: CGVector(dx: 10.0, dy: 0.0))

        let arrowTower = ArrowTower(position: CGPoint(x: 0, y: 100), entityManager: entityManager)
        entityManager.add(meleeUnit)
        guard let sprite = meleeUnit.component(ofType: SpriteComponent.self),
             let soldierSprite = soldierUnit.component(ofType: SpriteComponent.self),
        let arrowTowerSprite = arrowTower.component(ofType: SpriteComponent.self) else {
            return
        }
        addChild(sprite.node)
        addChild(soldierSprite.node)
        addChild(arrowTowerSprite.node)
        sprite.node.playAnimation()
        soldierSprite.node.playAnimation()
    }

    override func update(_ currentTime: TimeInterval) {
        guard let entityManager = entityManager else {
            return
        }
        if lastUpdatedTimeInterval == TimeInterval(0) {
            lastUpdatedTimeInterval = currentTime
        }
        let changeInTime = currentTime - lastUpdatedTimeInterval
        lastUpdatedTimeInterval = currentTime
        entityManager.update(changeInTime)
    }
}
