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

class UnitSelectionNode: TFEntity, UnitNodeDelegate {
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

        // Temporary until render pipeline is up
        // Initialised with dummy texture so that it doesn't crash
        let spriteComponent = SpriteComponent(textureNames: ["life"], height: 0, width: 0,
                                              position: CGPoint(x: 0, y: 0), animatableKey: "selectionNode")
        let node = spriteComponent.node
        node.isUserInteractionEnabled = true

        let possibleUnits: [(TFEntity & PlayerSpawnable).Type] = SpawnableEntities.playerSpawnableEntities
        var startingPoint = CGPoint(x: 400, y: 0)

        for type in possibleUnits {
            let unitNode = UnitNode(ofType: type)
            unitNode.position = startingPoint
            unitNodes.append(unitNode)
            unitNode.delegate = self
            node.addChild(unitNode)

            startingPoint.x += 140
        }

        // Position unit selection node on the left side of the screen
        node.position = CGPoint(x: 500, y: 100)

        self.addComponent(spriteComponent)
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(PositionComponent(position: node.position))
        self.addComponent(PlayerComponent(player: .ownPlayer))
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

    func update() {
        guard let homeComponent = self.component(ofType: HomeComponent.self) else {
            return
        }
        self.availablePoints = homeComponent.points
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
        delegate?.unitSelectionNodeDidSpawn(ofType: selectedType, position: position)
    }
}
