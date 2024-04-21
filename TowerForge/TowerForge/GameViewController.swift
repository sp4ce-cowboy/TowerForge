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
    var roomId: RoomId?
    var isHost = true
    var currentPlayer: GamePlayer?

    @IBOutlet private var gamePopupButton: UIButton!
    @IBAction private func onStatePressed(_ sender: Any) {
        self.pause()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        AudioManager.shared.playBackground()
        showGameLevelScene()
        let auth = AuthenticationProvider()
        if auth.isUserLoggedIn() {
            auth.getUserDetails { data, _ in
                Logger.log(String(describing: data), self)
                self.playerData = data
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
        self.gameWorld = GameWorld(screenSize: self.view.frame,
                                   mode: self.gameMode ?? .captureTheFlag,
                                   roomId: roomId, isHost: isHost, currentPlayer: currentPlayer)
        self.gameWorld?.scene = scene
        self.gameWorld?.delegate = self
        self.gameWorld?.statePopupDelegate = self
    }

    func pause() {
        isPaused = (roomId == nil && currentPlayer == nil) // Allow pausing only on singleplayer.
        gameWorld?.presentStatePopup()
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
        if let targetVC = navigationController?.viewControllers.first(where: { $0 is MainMenuViewController }) {
            navigationController?.popToViewController(targetVC, animated: true)
            return
        }
        if let targetVC = storyboard?
            .instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
            present(targetVC, animated: true)
        }
    }
    func showLevelScene() {
        // TODO : to implement after Keith is done
    }
    func showGameOverScene(isWin: Bool, results: [GameResult]) {
        let gameOverScene = GameOverScene(win: isWin, results: results)
        if isWin, let data = self.playerData {
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
        isPaused = false
        gameWorld?.concede(player: currentPlayer)
    }

    func onResume() {
        isPaused = false
        gameWorld?.removeStatePopup()
    }
}
