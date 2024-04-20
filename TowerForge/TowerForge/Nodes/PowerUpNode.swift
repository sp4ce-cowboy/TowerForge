//
//  PowerUpNode.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import SpriteKit

enum PowerUp: String {
    case invulnerability
    case damage
    case nocost

    var imageName: String {
        switch self {
        case .invulnerability:
            return "invulnerability"
        case .damage:
            return "damage"
        case .nocost:
            return "nocost"
        }
    }

    var cooldown: CGFloat {
        switch self {
        case .invulnerability:
            return CGFloat(10)
        case .damage:
            return CGFloat(10)
        case .nocost:
            return CGFloat(30)
        }
    }

    static var allPowerUps: [PowerUp] {
        [.invulnerability, .damage, .nocost]
    }
}

protocol PowerUpNodeDelegate: AnyObject {
    func powerUpNodeDidSelect()
}

class PowerUpNode: TFEntity {
    static let size = UnitNode.size
    let type: PowerUp
    var delegate: PowerUpNodeDelegate
    var enabled = true

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
        let buttonDelegate = TFButtonDelegate(onTouchBegan: onTouchBegan, onTouchEnded: {})
        addComponent(ButtonComponent(size: size, buttonDelegate: buttonDelegate))
    }

    private func onTouchBegan() {
        if !self.enabled {
            return
        }
        self.enabled = false
        update(alpha: 0.5)
        self.delegate.powerUpNodeDidSelect()
        Foundation.Timer.scheduledTimer(withTimeInterval: self.type.cooldown, repeats: false) { _ in
            self.enabled = true
            self.update(alpha: 1.0)
        }
    }

    private func update(alpha: CGFloat) {
        guard let spriteComponent = component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.alpha = alpha
    }
}
