//
//  GameViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import SpriteKit

class GameViewController: UIViewController {
    private var gameWorld: GameWorld?
    private var playerData: AuthenticationData?
    private var gameRankProvider: GameRankProvider?
    var gameMode: Mode?
    var isPaused = false
    var gameRoom: GameRoom?
    var currentPlayer: GamePlayer?

    @IBOutlet private var gamePopupButton: UIButton!
    @IBAction private func onStatePressed(_ sender: Any) {
        isPaused = true
        gameWorld?.presentStatePopup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AudioManager.shared.playBackground()
        showGameLevelScene()

        let auth = AuthenticationProvider()
        if auth.isUserLoggedIn() {
            auth.getUserDetails { data, _ in
                print(data)
                self.playerData = data
            }
        }
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
        guard let mainMenuViewController =
                self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController")
                as? MainMenuViewController else {
                    return
                }

        self.present(mainMenuViewController, animated: true, completion: nil)
    }
    func showLevelScene() {
        // TODO : to implement after Keith is done
    }
    func showGameOverScene(isWin: Bool, results: [GameResult]) {
        let gameOverScene = GameOverScene(win: isWin, results: results)
        if let data = self.playerData {
            for result in results {
                if let leaderboardResult = result as? LeaderboardResult, let score = Double(leaderboardResult.value) {
                    let rank = GameRankProvider(type: leaderboardResult.variable)
                    let data = GameRankData(userId: data.userId,
                                            username: data.username ?? "",
                                            score: score)
                    rank.setNewRank(rank: data)
                }
            }
        }
        gameOverScene.sceneManagerDelegate = self
        gamePopupButton.isHidden = true
        showScene(scene: gameOverScene)
    }
    func showGameLevelScene() {
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
        gameWorld?.removeStatePopup()
    }
}
