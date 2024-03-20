//
//  GameScene.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, UnitSelectionNodeDelegate {
    var sceneManagerDelegate: SceneManagerDelegate?
    
    private var lastUpdatedTimeInterval = TimeInterval(0)
    private var entityManager: EntityManager?
    private var selectionNode: UnitSelectionNode?

    override func didMove(to view: SKView) {
        entityManager = EntityManager()
        guard let entityManager = entityManager else {
            return
        }
        selectionNode = UnitSelectionNode()
        guard var selectionNode = selectionNode else {
            return
        }
        selectionNode.delegate = self
        addChild(selectionNode)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectionNode = selectionNode else {
            return
        }
        let location = touch.location(in: self)
        selectionNode.unitNodeDidSpawn(location)
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
    func unitSelectionNodeDidSpawn(unitType: UnitType, position: CGPoint) {
        guard var entityManager = entityManager else {
            return
        }
        UnitGenerator.spawnUnit(ofType: unitType, at: position, player: Player.ownPlayer, entityManager: entityManager, scene: self)
    }
}
