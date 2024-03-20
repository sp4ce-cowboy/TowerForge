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
    var purchasable = true
    var teamController: TeamController?
    var unitTitleLabel: SKLabelNode!
    var unitCostLabel: SKLabelNode!
    var backgroundNode: SKSpriteNode!

    convenience init(unitType: UnitType) {
        self.init(imageName: unitType.title, height: 200.0, width: 140.0)
        self.setupUnitCostLabel(cost: unitType.cost)
        self.unitType = unitType

        self.zPosition = 10.0
        isUserInteractionEnabled = true

        backgroundNode = SKSpriteNode(color: UIColor.blue, size: self.size)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
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
        delegate?.unitNodeDidSelect(self)

    }
}
