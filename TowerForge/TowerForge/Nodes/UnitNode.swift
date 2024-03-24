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
    let type: (TFEntity & PlayerSpawnable).Type
    weak var delegate: UnitNodeDelegate?
    var purchasable = true
    var teamController: TeamController?
    var unitTitleLabel: SKLabelNode!
    var unitCostLabel: SKLabelNode!
    var backgroundNode: SKSpriteNode!

    init<T: TFEntity & PlayerSpawnable>(ofType type: T.Type) {
        self.type = type
        super.init(imageName: type.title, height: 200.0, width: 140.0)

        setupUnitCostLabel(cost: type.cost)
        self.zPosition = 10.0
        isUserInteractionEnabled = true

        backgroundNode = SKSpriteNode(color: UIColor.clear, size: self.size)
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        guard touches.first != nil, purchasable else {
            return
        }
        delegate?.unitNodeDidSelect(self)
    }
}
