//
//  GameViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import SpriteKit

class GameViewController: UIViewController {
    private var gameWorld: GameWorld?
    var gameMode: Mode?
    var isPaused = false
    var gameRoom: GameRoom?
    var currentPlayer: GamePlayer?

    @IBAction private func onStatePressed(_ sender: Any) {
        isPaused = true
        gameWorld?.presentStatePopup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AchievementManager.incrementTotalGamesStarted()
        AudioManager.shared.playBackground()
        showGameLevelScene(level: 1) // TODO : Change hardcoded level value
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AudioManager.shared.pauseBackground()
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
        self.gameWorld = GameWorld(scene: scene, screenSize: self.view.frame,
                                   mode: self.gameMode ?? .captureTheFlag,
                                   gameRoom: gameRoom, currentPlayer: currentPlayer)
        self.gameWorld?.delegate = self
        self.gameWorld?.statePopupDelegate = self
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
        guard let gameScene = GameScene(fileNamed: "GameScene") else {
            return
        }
        // Present the scene
        gameScene.sceneManagerDelegate = self
        gameScene.updateDelegate = self
            gameScene.statePopupDelegate = self
        showScene(scene: gameScene)
        setUpGameWorld(scene: gameScene)
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

extension GameViewController: StatePopupDelegate {
    func onMenu() {
    }

    func onResume() {
        isPaused = false
    }
}
