//
//  GameOverScene.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var sceneManagerDelegate: SceneManagerDelegate?
    var win: Bool

    init(win: Bool) {
        self.win = win
        super.init(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        setupScene()
    }

    func setupScene() {
//        let background = TFSpriteNode(imageName: "background", height: frame.height, width: frame.width)
//        background.position = CGPoint(x: 0, y: 0)
//        background.anchorPoint = .zero
//        addChild(background)

        let label = SKLabelNode(text: self.win ? "WIN" : "LOST")
        label.position = CGPoint(x: 110, y: 110)
        label.fontSize = 24.0
        label.fontName = "Nosifer-Regular"
        label.fontColor = .darkGray
        label.zPosition = 1_000
        addChild(label)
    }
}
