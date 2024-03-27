//
//  GameViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import SpriteKit

class GameViewController: UIViewController {
    private var gameWorld: GameWorld?

    override func viewDidLoad() {
        super.viewDidLoad()
        showGameLevelScene(level: 1) // TODO : Change hardcoded level value
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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

    private func setUpGameWorld(scene: GameScene) {
        self.gameWorld = GameWorld(scene: scene, screenSize: self.view.frame)
        self.gameWorld?.delegate = self
    }
}

extension GameViewController: SceneUpdateDelegate {
    func touch(at location: CGPoint) {
        gameWorld?.spawnUnit(at: location)
    }

    func update(deltaTime: TimeInterval) {
        gameWorld?.update(deltaTime: deltaTime)
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
    func showGameOverScene(isWin: Bool) {
        let gameOverScene = GameOverScene(win: isWin)
        gameOverScene.sceneManagerDelegate = self
        showScene(scene: gameOverScene)
    }
    func showGameLevelScene(level: Int) {
        if let gameScene = GameScene(fileNamed: "GameScene") {
            // Present the scene
            gameScene.sceneManagerDelegate = self
            gameScene.updateDelegate = self
            showScene(scene: gameScene)
            setUpGameWorld(scene: gameScene)
        }
    }
    func showScene(scene: SKScene) {
        if let view = self.view as? SKView {
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true // to render nodes more efficiently
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
}
