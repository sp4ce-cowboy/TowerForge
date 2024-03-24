//
//  UnitSelectionNodeDelegate.swift
//  TowerForge
//
//  Created by Keith Gan on 24/3/24.
//

import SpriteKit

class SelectionNodeDelegate: UnitSelectionNodeDelegate {
    private var eventManager: EventManager
    private var gridDelegate: GridDelegate

    init(eventManager: EventManager, gridDelegate: GridDelegate) {
        self.eventManager = eventManager
        self.gridDelegate = gridDelegate
    }

    func unitSelectionNodeDidSpawn<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        if position.y < gridDelegate.UNIT_SELECTION_NODE_HEIGHT {
            return
        }
        let snapPosition = CGPoint(x: position.x, y: gridDelegate.snapYPosition(yPosition: position.y))
        eventManager.add(RequestSpawnEvent(ofType: type, timestamp: CACurrentMediaTime(), position: snapPosition, player: .ownPlayer))
    }
}
