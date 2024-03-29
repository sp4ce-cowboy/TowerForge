//
//  MenuScene.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import SpriteKit

class MenuScene: SKScene {
    var sceneManagerDelegate: SceneManagerDelegate?

    override func didMove(to view: SKView) {
        setupMenu()
    }

    func setupMenu() {
        let background = TFSpriteNode(imageName: "background", size: frame.size)
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = .zero
        addChild(background.node)
    }
}
