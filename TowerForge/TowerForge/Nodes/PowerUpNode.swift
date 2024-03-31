//
//  PowerUpNode.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import SpriteKit

enum PowerUp {
    case invulnerability

    var imageName: String {
        switch self {
        case .invulnerability:
            return "invulnerability"
        }
    }

    static var allPowerUps: [PowerUp] {
        [.invulnerability]
    }
}

protocol PowerUpNodeDelegate: AnyObject {
    func powerUpNodeDidSelect()
}

class PowerUpNode: TFSpriteNode {
    let type: PowerUp
    var delegate: PowerUpNodeDelegate
    var backgroundNode: SKSpriteNode!

    init(type: PowerUp, delegate: PowerUpNodeDelegate) {
        self.type = type
        self.delegate = delegate
        super.init(imageName: type.imageName, size: CGSize(width: 200.0, height: 140.0))
//
//        self.zPosition = 10.0
//        isUserInteractionEnabled = true
//
//        backgroundNode = SKSpriteNode(color: UIColor.clear, size: self.size)
//        backgroundNode.zPosition = -1
//        addChild(backgroundNode)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard touches.first != nil else {
//            return
//        }
//        delegate.powerUpNodeDidSelect()
    }
}
