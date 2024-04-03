//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import QuartzCore

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

    unowned var delegate: SceneManagerDelegate?

    init(scene: GameScene?, screenSize: CGRect, mode: Mode) {
        self.scene = scene
        worldBounds = CGRect(origin: screenSize.origin, size: GameWorld.worldSize)
        gameEngine = GameEngine()
        gameMode = GameModeFactory.createGameMode(mode: mode, eventManager: gameEngine.eventManager)
        selectionNode = UnitSelectionNode()
        powerUpSelectionNode = PowerUpSelectionNode(eventManager: gameEngine.eventManager)

        grid = Grid(screenSize: worldBounds)
        renderer = Renderer(target: self, scene: scene)

        setUp()
    }

    func update(deltaTime: TimeInterval) {
        gameEngine.updateGame(deltaTime: deltaTime)
        gameMode.updateGame()
        if checkGameEnded() {
            renderer?.renderMessage("You win")
            delegate?.showGameOverScene(isWin: gameMode.gameState == .WIN ? true : false)
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
}

extension GameWorld: Renderable {
    var entitiesToRender: [TFEntity] {
        gameEngine.entities
    }
}

extension GameWorld: UnitSelectionNodeDelegate {
    func unitSelectionNodeDidSpawn<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        gameEngine.addEvent(RequestSpawnEvent(ofType: type, timestamp: CACurrentMediaTime(),
                                              position: position, player: .ownPlayer))
    }
}
