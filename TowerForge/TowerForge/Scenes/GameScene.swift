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

        // Position unit selection node on the left side of the screen
        selectionNode.position = CGPoint(x: selectionNode.frame.width / 2, y: frame.midY)

        // Calculate vertical spacing between unit nodes
        let verticalSpacing = selectionNode.frame.height
        var verticalY = 10.0
        // Position unit nodes vertically aligned
        for (index, unitNode) in selectionNode.unitNodes.enumerated() {
            unitNode.position = CGPoint(x: selectionNode.frame.width / 2,
                                        y: verticalY)
            print(unitNode.position)
            verticalY += verticalSpacing
        }
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
