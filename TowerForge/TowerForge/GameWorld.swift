//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation

class GameWorld {
    private unowned var scene: GameScene?
    private var entityManager: EntityManager
    private var systemManager: SystemManager
    private var eventManager: EventManager
    private var selectionNode: UnitSelectionNode

    init(scene: GameScene?) {
        self.scene = scene
        entityManager = EntityManager()
        systemManager = SystemManager()
        eventManager = EventManager()
        selectionNode = UnitSelectionNode()

        selectionNode.delegate = self
        scene?.addChild(selectionNode)
        // Position unit selection node on the left side of the screen
        selectionNode.position = CGPoint(x: selectionNode.frame.width / 2, y: scene?.frame.midY ?? 300)

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

    func update(deltaTime: TimeInterval) {
        systemManager.update(deltaTime)
        eventManager.executeEvents(in: self)
        entityManager.update(deltaTime)
    }

    func spawnUnit(at location: CGPoint) {
        selectionNode.unitNodeDidSpawn(location)
    }
}

extension GameWorld: EventTarget {
    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }
}

extension GameWorld: UnitSelectionNodeDelegate {
    func unitSelectionNodeDidSpawn(unitType: UnitType, position: CGPoint) {
        guard let scene = scene else {
            return
        }
        print("here")
        UnitGenerator.spawnUnit(ofType: unitType, at: position, player: Player.ownPlayer, entityManager: entityManager, scene: scene)
    }
}
