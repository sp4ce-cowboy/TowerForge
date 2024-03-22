//
//  TFButton.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import SpriteKit

class TFButton: SKSpriteNode {
    var defaultButton: SKSpriteNode
    var buttonAction: (Int) -> Void
    var index: Int

    init(buttonImage: String, buttonAction: @escaping (Int) -> Void, index: Int) {
        defaultButton = SKSpriteNode(imageNamed: buttonImage)
        self.buttonAction = buttonAction
        self.index = index
        super.init(texture: nil, color: .clear, size: defaultButton.size)

        isUserInteractionEnabled = true
        addChild(defaultButton)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultButton.alpha = 0.9
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            if defaultButton.contains(location) {
                buttonAction(index)
            }
            defaultButton.alpha = 1.0
        }
    }

}
