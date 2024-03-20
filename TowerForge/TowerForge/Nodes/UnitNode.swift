//
//  UnitNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import SpriteKit

protocol UnitNodeDelegate: AnyObject {
    func unitNodeDidSelect(_ unitNode: UnitNode)
    func unitNodeDidSpawn(_ position: CGPoint)
}


class UnitNode: TFSpriteNode {
    var unitType: UnitType?
    weak var delegate: UnitNodeDelegate?
    var purchasable: Bool = true
    var teamController: TeamController?
    var unitTitleLabel: SKLabelNode!
    var unitCostLabel: SKLabelNode!
    var backgroundNode: SKSpriteNode!
    
    convenience init(unitType: UnitType, textures: TFTextures) {
        self.init(textures: textures, height: 20.0, width: 10.0)
        self.setupUnitTitleLabel(text: unitType.title)
        self.setupUnitCostLabel(cost: unitType.cost)
        self.unitType = unitType
        
        self.zPosition = 10.0
        isUserInteractionEnabled = true
        
        backgroundNode = SKSpriteNode(color: UIColor.blue, size: self.size)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if !purchasable {
            return
        }
        let location = touch.location(in: self)
        // Check if the touch is inside the node
        if self.contains(location) {
            delegate?.unitNodeDidSelect(self)
        }
    }
}
