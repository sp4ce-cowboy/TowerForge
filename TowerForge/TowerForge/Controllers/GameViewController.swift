//
//  GameViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showGameLevelScene(level: 1) // TODO : Change hardcoded level value
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}

extension GameViewController: SceneManagerDelegate {
    func showMenuScene() {
        let menuScene = MenuScene()
        menuScene.sceneManagerDelegate = self
        showScene(scene: menuScene)
    }
    func showLevelScene() {
        // TODO : to implement after Keith is done
    }
    func showGameLevelScene(level: Int) {
        if let gameScene = SKScene(fileNamed: "GameScene") as? GameScene {
            // Present the scene
            gameScene.sceneManagerDelegate = self
            showScene(scene: gameScene)
        }
    }
    func showScene(scene: SKScene) {
        if let view = self.view as? SKView {
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true // to render nodes more efficiently
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
