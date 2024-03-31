//
//  TFButton.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import SpriteKit

struct TFButtonDelegate {
    var onTouchBegan: () -> Void
    var onTouchEnded: () -> Void
}

private class TFButton: SKSpriteNode {
    private var action: TFButtonDelegate?
    init(buttonAction: TFButtonDelegate?, size: CGSize) {
        self.action = buttonAction
        super.init(texture: nil, color: .clear, size: size)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action?.onTouchBegan()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        action?.onTouchEnded()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TFButtonNode: TFNode {
    init(action: TFButtonDelegate?, size: CGSize) {
        super.init()
        node = TFButton(buttonAction: action, size: size)
    }
}
