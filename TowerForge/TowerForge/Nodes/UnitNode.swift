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
    private static let size = CGSize(width: 140, height: 200)

    let type: (TFEntity & PlayerSpawnable).Type
    weak var delegate: UnitNodeDelegate?
    var purchasable = true

    init<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        self.type = type
        super.init()
        let spriteComponent = SpriteComponent(textureNames: [type.title], size: UnitNode.size, animatableKey: "node")
        addComponent(spriteComponent)
        addComponent(PositionComponent(position: position))
        setUpButtonComponent(size: UnitNode.size)
        setupLabelComponent(cost: type.cost, displacement: CGVector(dx: -UnitNode.size.width, dy: 0))

        spriteComponent.staticOnScreen = true
    }

    func update(alpha: CGFloat) {
        guard let spriteComponent = component(ofType: SpriteComponent.self) else {
            return
        }
        spriteComponent.alpha = alpha
    }

    private func setUpButtonComponent(size: CGSize) {
        let buttonDelegate = TFButtonDelegate(onTouchBegan: { self.delegate?.unitNodeDidSelect(self) },
                                              onTouchEnded: {})
        addComponent(ButtonComponent(size: size, buttonDelegate: buttonDelegate))
    }

    private func setupLabelComponent(cost amount: Int, displacement: CGVector) {
        let labelComponent = LabelComponent(text: String(amount), name: "unitLabel")
        labelComponent.fontColor = .yellow
        labelComponent.fontSize = 20.0
        labelComponent.zPosition = 10.0
        labelComponent.displacement = displacement
        labelComponent.verticalAlignment = .trailing
        labelComponent.horizontalAlignment = .center
        addComponent(labelComponent)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
