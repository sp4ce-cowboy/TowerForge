//
//  UnitNode.swift
//  TowerForge
//
//  Created by MacBook Pro on 20/03/24.
//

import SpriteKit

class UnitNode: TFSpriteNode {
    var unitType: UnitType?
    var teamController: TeamController?
    var unitTitleLabel: SKLabelNode!
    var unitCostLabel: SKLabelNode!
    var backgroundNode: SKSpriteNode!
    // TODO : Make it more good looking
    convenience init(unitType: UnitType, textures: TFTextures) {
        self.init(textures: textures, height: 20.0, width: 10.0)
        self.setupUnitTitleLabel(text: unitType.title)
        self.setupUnitCostLabel(cost: unitType.cost)
        self.unitType = unitType
        
        backgroundNode = SKSpriteNode(color: UIColor.blue, size: self.size)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
    }
    func sellUnit() {
        guard let teamController = teamController else {
            return
        }
        teamController.spawn()
    }
    private func setupUnitTitleLabel(text: String) {
        unitTitleLabel = SKLabelNode()
        unitTitleLabel.name = "unitTitle"
        unitTitleLabel.fontColor = .yellow
        unitTitleLabel.fontSize = 30.0
        unitTitleLabel.text = text
        unitTitleLabel.zPosition = 10.0
        unitTitleLabel.verticalAlignmentMode = .bottom
        unitTitleLabel.horizontalAlignmentMode = .center
        self.addChild(unitTitleLabel)
    }
    
    private func setupUnitCostLabel(cost amount: Int) {
        unitCostLabel = SKLabelNode()
        unitCostLabel.name = "unitLabel"
        unitCostLabel.fontColor = .yellow
        unitCostLabel.fontSize = 20.0
        unitCostLabel.text = String(amount)
        unitCostLabel.zPosition = 10.0
        unitCostLabel.verticalAlignmentMode = .bottom
        unitCostLabel.horizontalAlignmentMode = .center
        self.addChild(unitCostLabel)
    }
}
