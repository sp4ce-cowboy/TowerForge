//
//  UnitSelectionNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import Foundation
import UIKit

protocol UnitSelectionNodeDelegate: AnyObject {
    func unitSelectionNodeDidSpawn(unitType: UnitType, position: CGPoint)
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
        super.init(textures: nil, height: 30.0, width: 100.0)
        isUserInteractionEnabled = true
        super.position = CGPoint(x: 100, y: 100)
        let horizontalSpacing: CGFloat = 50.0
        var currentXPosition: CGFloat = 0.0
        
        for (index, unit) in UnitType.possibleUnits.enumerated() {
            let unitNode = UnitNode(unitType: unit, textures: TFTextures(textureNames: unit.textures, textureAtlasName: "Sprite"))
            unitNode.delegate = self
            addChild(unitNode)
            
            // Adjust x position
            unitNode.position = CGPoint(x: currentXPosition, y: 0.0)
            currentXPosition += unitNode.size.width + horizontalSpacing
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func updateUnitAlphas() {
        for unitNode in unitNodes {
            if let unit = unitNode.unitType {
                if unit.cost <= availablePoints {
                    unitNode.alpha = 1.0
                    unitNode.purchasable = true
                } else {
                    unitNode.alpha = 0.5
                    unitNode.purchasable = false
                }
            }
        }
    }
    func unitNodeDidSelect(_ unitNode: UnitNode) {
        if unitNode.purchasable {
            selectedNode = unitNode
        }
    }
    
    func unitNodeDidSpawn(_ position: CGPoint) {
        guard let selectedUnitType = self.selectedNode?.unitType else {
            return
        }
        delegate?.unitSelectionNodeDidSpawn(unitType: selectedUnitType, position: position)
    }
}
