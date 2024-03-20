//
//  UnitSelectionNode.swift
//  TowerForge
//
//  Created by MacBook Pro on 20/03/24.
//

import Foundation

class UnitSelectionNode: TFSpriteNode {
    //var teamController: TeamController?
    var availablePoints: Int = 0 {
        didSet {
            updateUnitAlphas()
        }
    }
    var unitNodes: [UnitNode] = []
    
    init() {
        super.init(textures: nil, height: 30.0, width: 100.0)
        for (index, unit) in UnitType.possibleUnits.enumerated() {
            let unitNode = UnitNode(unitType: unit, textures: TFTextures(textureNames: unit.textures, textureAtlasName: "Sprite"))
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
                } else {
                    unitNode.alpha = 0.5
                }
            }
        }
    }
    
}
