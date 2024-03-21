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
    private var renderer: Renderer?

    init(scene: GameScene?) {
        self.scene = scene
        entityManager = EntityManager()
        systemManager = SystemManager()
        eventManager = EventManager()
        selectionNode = UnitSelectionNode()
        renderer = Renderer(target: self, scene: scene)

        self.setUpSelectionNode()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(deltaTime)
        eventManager.executeEvents(in: self)
        entityManager.update(deltaTime)
        renderer?.render()
    }

    func spawnUnit(at location: CGPoint) {
        selectionNode.unitNodeDidSpawn(location)
    }

    private func setUpSelectionNode() {

        selectionNode.delegate = self
        scene?.addChild(selectionNode)
        // Position unit selection node on the left side of the screen
        selectionNode.position = CGPoint(x: selectionNode.frame.width / 2, y: scene?.frame.midY ?? 300)

        // Calculate vertical spacing between unit nodes
        let verticalSpacing = selectionNode.frame.height
        var verticalY = 10.0
        // Position unit nodes vertically aligned
        for unitNode in selectionNode.unitNodes {
            unitNode.position = CGPoint(x: selectionNode.frame.width / 2,
                                        y: verticalY)
            verticalY += verticalSpacing
        }
    }
}

extension GameWorld: EventTarget {
    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }
}

extension GameWorld: UnitSelectionNodeDelegate {
    func unitSelectionNodeDidSpawn<T: BaseUnit & Spawnable>(ofType type: T.Type, position: CGPoint) {
        let unit = UnitGenerator.spawn(ofType: type, at: position, player: Player.ownPlayer,
                                       entityManager: entityManager)
        entityManager.add(unit)
    }
}

extension GameWorld: Renderable {
    func entitiesToRender() -> [TFEntity] {
        entityManager.entities
    }
}
