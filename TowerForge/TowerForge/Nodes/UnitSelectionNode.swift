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

class UnitSelectionNode: TFEntity {
    weak var delegate: UnitSelectionNodeDelegate?
    var availablePoints: Int = 0 {
        didSet {
            updateUnitAlphas()
        }
    }
    var unitNodes: [UnitNode] = []
    var selectedNode: UnitNode?

    override init() {
        super.init()

        var position = CGPoint(x: 500, y: 100)
        let possibleUnits: [(TFEntity & PlayerSpawnable).Type] = SpawnableEntities.playerSpawnableEntities
        for type in possibleUnits {
            let unitNode = UnitNode(ofType: type, position: position)
            unitNode.delegate = self
            position.x += 140
            unitNodes.append(unitNode)
        }

        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(PlayerComponent(player: .ownPlayer))
    }

    func update() {
        guard let homeComponent = self.component(ofType: HomeComponent.self) else {
            return
        }
        self.availablePoints = homeComponent.points
    }

    private func updateUnitAlphas() {
        for unitNode in unitNodes {
            if unitNode.type.cost <= availablePoints {
                unitNode.update(alpha: 1.0)
                unitNode.purchasable = true
            } else {
                unitNode.update(alpha: 0.5)
                unitNode.purchasable = false
            }
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UnitSelectionNode: UnitNodeDelegate {
    func unitNodeDidSelect(_ unitNode: UnitNode) {
        if unitNode.purchasable {
            selectedNode = unitNode
        }
    }

    func unitNodeDidSpawn(_ position: CGPoint) {
        guard let selectedType = self.selectedNode?.type else {
            return
        }
        delegate?.unitSelectionNodeDidSpawn(ofType: selectedType, position: position)
    }
}
