//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import QuartzCore
import UIKit

class GameWorld {
    // Need to ensure that width is a multiple of 1024 - unit selection node height
    static let worldSize = CGSize(width: 2_472, height: 1_024)

    private unowned var scene: GameScene?
    private var gameEngine: AbstractGameEngine
    private var gameMode: GameMode
    private var selectionNode: UnitSelectionNode
    private var powerUpSelectionNode: PowerUpSelectionNode
    private var grid: Grid
    private var renderer: Renderer?
    private let worldBounds: CGRect
    private var popup: StatePopupNode

    unowned var delegate: SceneManagerDelegate?
    unowned var statePopupDelegate: StatePopupDelegate? { didSet { popup.delegate = statePopupDelegate }  }

    init(scene: GameScene?, screenSize: CGRect, mode: Mode,
         gameRoom: GameRoom? = nil, currentPlayer: GamePlayer? = nil) {
        self.scene = scene
        worldBounds = CGRect(origin: screenSize.origin, size: GameWorld.worldSize)
        gameEngine = GameEngine(roomId: gameRoom?.roomId, currentPlayer: currentPlayer)
        gameMode = GameModeFactory.createGameMode(mode: mode, eventManager: gameEngine.eventManager)
        selectionNode = UnitSelectionNode()
        powerUpSelectionNode = PowerUpSelectionNode(eventManager: gameEngine.eventManager)
        grid = Grid(screenSize: worldBounds)
        popup = StatePopupNode()
        renderer = TFRenderer(target: self, scene: scene)

        setUp()
    }

    func update(deltaTime: TimeInterval) {
        gameEngine.updateGame(deltaTime: deltaTime)
        gameMode.updateGame(deltaTime: deltaTime)
        if checkGameEnded() {
            renderer?.renderMessage("You win")
            print(gameMode.gameState)
            delegate?.showGameOverScene(isWin: gameMode.gameState == .WIN, results: gameMode.getGameResults())
        }
        selectionNode.update()
        renderer?.render()
    }

    func checkGameEnded() -> Bool {
        gameMode.gameState == .WIN || gameMode.gameState == .LOSE || gameMode.gameState == .DRAW
    }

    func spawnUnit(at location: CGPoint) {
        selectionNode.unitNodeDidSpawn(location)
    }

    private func setUp() {
        setUpScene()
        setUpGameEngine()
        setUpSelectionNode()
        setUpPowerUpNode()
        setUpStatePopupNode()
    }

    private func setUpScene() {
        scene?.setBounds(worldBounds)
        if let scene = self.scene {
            grid.generateTileMap(scene: scene)
        }
        renderer?.renderMessage("Game Starts")

    }

    private func setUpGameEngine() {
        gameEngine.setUpSystems(with: grid)
        gameEngine.setUpPlayerInfo(mode: gameMode)
    }

    private func setUpSelectionNode() {
        selectionNode.delegate = self
        gameEngine.addEntity(selectionNode)
        for node in selectionNode.unitNodes {
            gameEngine.addEntity(node)
        }
    }

    private func setUpPowerUpNode() {
        gameEngine.addEntity(powerUpSelectionNode)
        for node in powerUpSelectionNode.powerupNodes {
            gameEngine.addEntity(node)
        }
    }

    private func setUpStatePopupNode() {
        popup.zPosition = 10_000
        popup.name = "popup"
        popup.position = CGPoint(x: 0, y: 0)
    }

    func presentStatePopup() {
        scene?.add(node: popup, staticOnScreen: true)
    }

    func removeStatePopup() {
        scene?.remove(node: popup)
    }
}

extension GameWorld: Renderable {
    var entitiesToRender: [TFEntity] {
        gameEngine.entities
    }

    func entities<T: TFComponent>(with componentType: T.Type) -> [TFEntity] {
        gameEngine.entities(with: componentType)
    }
}

extension GameWorld: UnitSelectionNodeDelegate {
    func unitSelectionNodeDidSpawn<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        gameEngine.addEvent(RequestSpawnEvent(ofType: type, timestamp: CACurrentMediaTime(),
                                              position: position, player: .ownPlayer))
    }
}
