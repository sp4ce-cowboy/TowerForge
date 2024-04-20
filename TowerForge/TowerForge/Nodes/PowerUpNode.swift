//
//  PowerUpNode.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import SpriteKit

enum PowerUp: String {
    case Invulnerability
    case Damage
    case NoCost

    var imageName: String {
        switch self {
        case .Invulnerability:
            return "invulnerability"
        case .Damage:
            return "damage"
        case .NoCost:
            return "nocost"
        }
    }

    var cooldown: CGFloat {
        switch self {
        case .Invulnerability:
            return CGFloat(10)
        case .Damage:
            return CGFloat(10)
        case .NoCost:
            return CGFloat(30)
        }
    }

    static var allPowerUps: [PowerUp] {
        [.Invulnerability, .Damage, .NoCost]
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
