//
//  StatePopupNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 05/04/24.
//

import Foundation
import UIKit

protocol StatePopupDelegate {
    func onMenu()
    func onResume()
}

class StatePopupNode: TFSpriteNode {

    var delegate: StatePopupDelegate?

    init() {
        super.init(color: .clear, size: CGSize(width: 300, height: 300))
        setupNode()
    }

    func setupNode() {
        let background = TFSpriteNode(imageName: "square-button", size: self.size)

        // TODO: Refactor into a constant
        background.position = CGPoint(x: self.size.width / 2,
                                      y: self.size.height / 2)
        let resumeButton = TFButtonNode(action: TFButtonDelegate(onTouchBegan: { [weak self] in
            self?.delegate?.onResume()
        },
                            onTouchEnded: {}),
                            size: CGSize(width: 100,
                                         height: 50),
                            imageNamed: "circle-button")

        let menuButton = TFButtonNode(action: TFButtonDelegate(onTouchBegan: { [weak self] in
            self?.delegate?.onMenu()
        }, onTouchEnded: {}), size: CGSize(width: 100, height: 50), imageNamed: "circle-button")

        // TODO: Refactor the position into a constants
        resumeButton.position = CGPoint(x: background.position.x + 150, y: background.position.y)
        menuButton.position = CGPoint(x: background.position.x - 150, y: background.position.y)

        print("Adding to scene")
        add(child: background)
        add(child: menuButton)
        add(child: resumeButton)
    }

}
