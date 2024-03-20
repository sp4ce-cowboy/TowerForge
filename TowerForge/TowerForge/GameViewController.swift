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
    private var scene: GameScene?
    private var gameWorld: GameWorld?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUp()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scene = nil
        gameWorld = nil
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

    private func setUp() {
        setUpScene()
        setUpGameWorld()
    }

    private func setUpScene() {
        if let view = self.view as? SKView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = GameScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
                self.scene = scene
                scene.updateDelegate = self
            }

            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    private func setUpGameWorld() {
        self.gameWorld = GameWorld(scene: scene)
    }
}

extension GameViewController: SceneUpdateDelegate {
    func update(deltaTime: TimeInterval) {
        gameWorld?.update(deltaTime: deltaTime)
    }
}
