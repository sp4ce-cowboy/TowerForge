//
//  PointNode.swift
//  TowerForge
//
//  Created by MacBook Pro on 23/03/24.
//

import Foundation
import SpriteKit

class PointNode: TFSpriteNode {
    var amount: Int
    var amountLabel: SKLabelNode!

    init(amount: Int) {
        self.amount = amount
        super.init(imageName: "Coin", height: 20.0, width: 20.0)
        self.setupPointLabel(cost: amount)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.position = CGPoint(x: 0, y: 0)
        self.zPosition = 100
    }
    private func setupPointLabel(cost amount: Int) {
        amountLabel = SKLabelNode()
        amountLabel.name = "pointLabel"
        amountLabel.fontColor = .yellow
        amountLabel.fontSize = 20.0
        amountLabel.text = String(amount)
        amountLabel.zPosition = 100.0
        amountLabel.verticalAlignmentMode = .bottom
        amountLabel.horizontalAlignmentMode = .left
        amountLabel.position = CGPoint(x: 20, y: 0)
        self.addChild(amountLabel)
    }
    func updatePoint(_ amount: Int) {
        self.amount = amount
    }
}
