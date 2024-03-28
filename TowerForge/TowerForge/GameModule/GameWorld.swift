//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import QuartzCore

class GameWorld {
    private unowned var scene: GameScene?
    private var gameEngine: AbstractGameEngine
    private var gameMode: GameMode
    private var selectionNode: UnitSelectionNode
    private var grid: Grid
    private var renderer: Renderer?

    init(scene: GameScene?, screenSize: CGRect) {
        self.scene = scene
        gameEngine = GameEngine()
        gameMode = GameModeFactory.createGameMode(mode: .captureTheFlag, eventManager: gameEngine.eventManager)
        selectionNode = UnitSelectionNode()

        grid = Grid(screenSize: screenSize)
        if let scene = self.scene {
            grid.generateTileMap(scene: scene)
        }

        renderer = Renderer(target: self, scene: scene)
        renderer?.renderMessage("Game Starts")
        gameEngine.setUpSystems(with: grid)
        gameEngine.setUpPlayerInfo(mode: gameMode)
        self.setUpSelectionNode()
    }

    func update(deltaTime: TimeInterval) {
        gameEngine.updateGame(deltaTime: deltaTime)
        gameMode.updateGame()
        if checkGameEnded() {
            renderer?.renderMessage("You win")
        }
        selectionNode.update()
        renderer?.render()
    }
    func checkGameEnded() -> Bool {
        gameMode.gameState == .WIN || gameMode.gameState == .LOSE
    }
    func spawnUnit(at location: CGPoint) {
        selectionNode.unitNodeDidSpawn(location)
    }

    private func setUpSelectionNode() {
        selectionNode.delegate = self
        // Calculate vertical spacing between unit nodes
        var horizontalX = 10.0
        // Position unit nodes vertically aligned
        for unitNode in selectionNode.unitNodes {
            let horizontalSpacing = unitNode.frame.width
            unitNode.position = CGPoint(x: horizontalX,
                                        y: 0)
            horizontalX += horizontalSpacing
        }
        gameEngine.addEntity(selectionNode)
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
