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
    let type: (TFEntity & PlayerSpawnable).Type
    weak var delegate: UnitNodeDelegate?
    var purchasable = true

    init<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        self.type = type
        super.init()
        let size = CGSize(width: 140, height: 200)
        addComponent(SpriteComponent(textureNames: [type.title], size: size, animatableKey: "node"))
        addComponent(PositionComponent(position: position))
        setUpButtonComponent(size: size)
        setupLabelComponent(cost: type.cost, displacement: CGVector(dx: -size.width, dy: 0))
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
