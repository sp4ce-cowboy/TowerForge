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
    var results: [GameResult]

    init(win: Bool, results: [GameResult]) {
        self.win = win
        self.results = results
        super.init(size: CGSize(width: SizeConstants.SCREEN_SIZE.width,
                                height: SizeConstants.SCREEN_SIZE.height))
    }

    override func didMove(to view: SKView) {
        setupScene()
        AudioManager.shared.stopBackground()
        if self.win {
            AudioManager.shared.playWinSoundEffect()
        } else {
            AudioManager.shared.playLoseSoundEffect()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)

        if let node = self.nodes(at: touchLocation).first {
            if node.contains(touchLocation) {
                sceneManagerDelegate?.showMenuScene()
            }
        }
    }

    func setupScene() {
        let label = TFLabelNode(text: self.win ? "WIN" : "LOST")
        label.position = CGPoint(x: SizeConstants.SCREEN_SIZE.width / 2, y: SizeConstants.SCREEN_SIZE.height * 0.9)
        label.fontSize = 44.0
        label.fontName = "Nosifer-Regular"
        label.fontColor = .darkGray
        label.zPosition = 1_000
        addChild(label.node)

        setupResultsUI()
    }

    func setupResultsUI() {
        var yOffset: CGFloat = 80.0
        let labelFontSize: CGFloat = 16.0
        let labelFontName = "Nosifer-Regular"

        for result in results {
            let resultLabel = TFLabelNode(text: "\(result.variable): \(result.value)")
            resultLabel.fontSize = labelFontSize
            resultLabel.fontName = labelFontName
            resultLabel.fontColor = .darkGray
            resultLabel.position = CGPoint(x: SizeConstants.SCREEN_SIZE.width / 2,
                                           y: SizeConstants.SCREEN_SIZE.height * 0.8 - yOffset)
            addChild(resultLabel.node)

            yOffset += 30.0
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
