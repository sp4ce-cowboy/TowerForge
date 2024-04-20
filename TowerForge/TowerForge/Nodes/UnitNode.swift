//
//  UnitNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import SpriteKit

/// TODO: Add documentation for this
protocol UnitNodeDelegate: AnyObject {
    func unitNodeDidSelect(_ unitNode: UnitNode)
}

class UnitNode: TFEntity {
    static var size: CGSize {
        let height = SizeConstants.TOOLBAR_HEIGHT
        let width = height * 0.7
        return CGSize(width: width, height: height)
    }

    let type: (TFEntity & PlayerSpawnable).Type
    weak var delegate: UnitNodeDelegate?
    var purchasable = true

    init<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        self.type = type
        super.init()
        setUpSpriteComponent()
        addComponent(PositionComponent(position: position))
        setUpButtonComponent(size: UnitNode.size)
        setupLabelComponent(cost: type.cost, displacement: CGVector(dx: -UnitNode.size.width, dy: 0))

    }

    func update(alpha: CGFloat) {
        guard let spriteComponent = component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.alpha = alpha
    }

    private func setUpSpriteComponent() {
        let spriteComponent = SpriteComponent(textureNames: [type.title], size: UnitNode.size, animatableKey: "node")
        spriteComponent.tint = .black
        spriteComponent.zPosition = 1_000
        addComponent(spriteComponent)
        spriteComponent.staticOnScreen = true
    }

    private func setUpButtonComponent(size: CGSize) {
        let buttonDelegate = TFButtonDelegate(onTouchBegan: { self.delegate?.unitNodeDidSelect(self) },
                                              onTouchEnded: {})
        let buttonComponent = ButtonComponent(size: size, buttonDelegate: buttonDelegate)
        addComponent(buttonComponent)
    }

    private func setupLabelComponent(cost amount: Int, displacement: CGVector) {
        let labelComponent = LabelComponent(text: String(amount), name: "unitLabel")
        labelComponent.fontColor = .yellow
        labelComponent.fontSize = 20.0
        labelComponent.zPosition = 10_000
        labelComponent.displacement = displacement
        labelComponent.verticalAlignment = .trailing
        labelComponent.horizontalAlignment = .center
        addComponent(labelComponent)
    }
}
