//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

class GameWorld {
    private unowned var scene: GameScene?
    private var gameEngine: AbstractGameEngine
    private var selectionNode: UnitSelectionNode
    private var grid: Grid
    private var renderer: Renderer?

    init(scene: GameScene?, screenSize: CGRect) {
        self.scene = scene
        gameEngine = GameEngine()
        selectionNode = UnitSelectionNode()

        grid = Grid(screenSize: screenSize)
        if let scene = self.scene {
            grid.generateTileMap(scene: scene)
        }

        renderer = Renderer(target: self, scene: scene)
        renderer?.renderMessage("Game Starts")
        gameEngine.setUpSystems(with: grid)
        self.setUpSelectionNode()
    }

    func update(deltaTime: TimeInterval) {
        gameEngine.updateGame(deltaTime: deltaTime)
        selectionNode.update()
        renderer?.render()
    }
    func spawnUnit(at location: CGPoint) {
        selectionNode.unitNodeDidSpawn(location)
    }

    func contactDidBegin(between idA: UUID, and idB: UUID) {
        gameEngine.contactDidEnd(between: idA, and: idB)
    }

    func contactDidEnd(between idA: UUID, and idB: UUID) {
        gameEngine.contactDidEnd(between: idA, and: idB)
    }

    private func setUpSelectionNode() {
        selectionNode.delegate = self
//        scene?.addChild(selectionNode)
//        // Position unit selection node on the left side of the screen
//        selectionNode.position = CGPoint(x: 500, y: selectionNode.height / 2)
//
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
    func entitiesToRender() -> [TFEntity] {

        gameEngine.entities
    }
}

extension GameWorld: UnitSelectionNodeDelegate {
    func unitSelectionNodeDidSpawn<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        gameEngine.addEvent(RequestSpawnEvent(ofType: type, timestamp: CACurrentMediaTime(),
                                              position: position, player: .ownPlayer))
    }
}
