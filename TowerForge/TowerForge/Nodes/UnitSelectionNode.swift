//
//  UnitSelectionNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import Foundation
import UIKit

protocol UnitSelectionNodeDelegate: AnyObject {
    func unitSelectionNodeDidSpawn<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint)
}

class UnitSelectionNode: TFSpriteNode, UnitNodeDelegate {
    weak var delegate: UnitSelectionNodeDelegate?
    var availablePoints: Int = 100 {
        didSet {
            updateUnitAlphas()
        }
    }
    var unitNodes: [UnitNode] = []
    var selectedNode: UnitNode?

    init() {
        super.init(textures: nil, height: 200.0, width: 100.0)

        isUserInteractionEnabled = true
        let possibleUnits: [(TFEntity & PlayerSpawnable).Type] = SpawnableEntities.playerSpawnableEntities
        for type in possibleUnits {
            let unitNode = UnitNode(ofType: type)
            unitNodes.append(unitNode)
            unitNode.delegate = self
            addChild(unitNode)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateUnitAlphas() {
        for unitNode in unitNodes {
            if unitNode.type.cost <= availablePoints {
                unitNode.alpha = 1.0
                unitNode.purchasable = true
            } else {
                unitNode.alpha = 0.5
                unitNode.purchasable = false
            }
        }
    }

    func unitNodeDidSelect(_ unitNode: UnitNode) {
        if unitNode.purchasable {
            selectedNode = unitNode
        }
    }

    func unitNodeDidSpawn(_ position: CGPoint) {
        guard let selectedType = self.selectedNode?.type else {
            return
        }
        self.availablePoints -= selectedType.cost
        delegate?.unitSelectionNodeDidSpawn(ofType: selectedType, position: position)
    }
}
