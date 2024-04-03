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

class PowerUpNode: TFEntity {
    static let size = CGSize(width: 140, height: 200)
    let type: PowerUp
    var delegate: PowerUpNodeDelegate

    init(type: PowerUp, delegate: PowerUpNodeDelegate, at position: CGPoint) {
        self.type = type
        self.delegate = delegate
        super.init()

        let spriteComponent = SpriteComponent(textureNames: [type.imageName], size: PowerUpNode.size,
                                              animatableKey: "node")
        addComponent(spriteComponent)
        addComponent(PositionComponent(position: position))
        setUpButtonComponent(size: PowerUpNode.size)
        spriteComponent.staticOnScreen = true
    }

    private func setUpButtonComponent(size: CGSize) {
        let buttonDelegate = TFButtonDelegate(onTouchBegan: { self.delegate.powerUpNodeDidSelect() }, onTouchEnded: {})
        addComponent(ButtonComponent(size: size, buttonDelegate: buttonDelegate))
    }
}
