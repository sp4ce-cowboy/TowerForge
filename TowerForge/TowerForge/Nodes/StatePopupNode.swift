//
//  StatePopupNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 05/04/24.
//

import Foundation
import UIKit

protocol StatePopupDelegate: AnyObject {
    func onMenu()
    func onResume()
}

class StatePopupNode: TFSpriteNode {

    var delegate: StatePopupDelegate?

    init() {
        super.init(color: .clear, size: CGSize(width: 700, height: 300))
        setupNode()
    }

    func setupNode() {
        let background = TFSpriteNode(imageName: "square-button", size: self.size)

        // TODO: Refactor into a constant
        background.position = CGPoint(x: 0, y: 0)
        background.name = "statePopupNode"

        let resumeButton = TFButtonNode(action: TFButtonDelegate(onTouchBegan: { [weak self] in
            self?.delegate?.onResume()
        },
                            onTouchEnded: {}),
                            size: CGSize(width: 200,
                                         height: 200),
                            imageNamed: "play-button")
        resumeButton.name = "resumeButton"

        let menuButton = TFButtonNode(action: TFButtonDelegate(onTouchBegan: { [weak self] in
            self?.delegate?.onMenu()
        }, onTouchEnded: {}), size: CGSize(width: 200, height: 200), imageNamed: "menu-button")
        menuButton.name = "menuButton"

        // TODO: Refactor the position into a constants
        resumeButton.position = CGPoint(x: background.position.x + 150, y: background.position.y)
        menuButton.position = CGPoint(x: background.position.x - 150, y: background.position.y)

        background.zPosition = self.zPosition + 10
        resumeButton.zPosition = self.zPosition + 20
        menuButton.zPosition = self.zPosition + 20

        self.add(child: background)
        self.add(child: menuButton)
        self.add(child: resumeButton)

    }

}
