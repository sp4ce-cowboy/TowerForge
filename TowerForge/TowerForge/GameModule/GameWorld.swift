//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation
import SpriteKit

class GameWorld {
    private unowned var scene: GameScene?
    private var entityManager: EntityManager
    private var systemManager: SystemManager
    private var eventManager: EventManager
    private var selectionNode: UnitSelectionNode
    private var selectionNodeDelegate: SelectionNodeDelegate
    private var grid: Grid
    private var renderer: Renderer?

    init(scene: GameScene?, screenSize: CGRect) {
        self.scene = scene
        entityManager = EntityManager()
        systemManager = SystemManager()
        eventManager = EventManager()
        selectionNode = UnitSelectionNode()

        grid = Grid(screenSize: screenSize)
        if let scene = self.scene {
            grid.generateTileMap(scene: scene)
        }
        self.selectionNodeDelegate = SelectionNodeDelegate(eventManager: eventManager, gridDelegate: grid)
        renderer = Renderer(target: self, scene: scene)
        renderer?.renderMessage("Game Starts")
        self.setUpSystems()
        self.setUpSelectionNode()
        self.setupTeam()
        self.setupPlayerInfo()
    }

    func update(deltaTime: TimeInterval) {
        systemManager.update(deltaTime)
        eventManager.executeEvents(in: self)
        renderer?.render()
    }
    func spawnUnit(at location: CGPoint) {
        selectionNode.unitNodeDidSpawn(location)
    }

    func setupTeam() {
        let ownTeam = Team(player: .ownPlayer)
        let oppositeTeam = Team(player: .oppositePlayer)
        entityManager.add(ownTeam)
        entityManager.add(oppositeTeam)
    }
    func setupPlayerInfo() {
        let point = Point(initialPoint: 0)
        entityManager.add(point)

        let life = Life(initialLife: Team.lifeCount)
        entityManager.add(life)
    }
    func contactDidBegin(between idA: UUID, and idB: UUID) {
        systemManager.system(ofType: ContactSystem.self)?.insert(contact: TFContact(entityIdA: idA, entityIdB: idB))
    }

    func contactDidEnd(between idA: UUID, and idB: UUID) {
        systemManager.system(ofType: ContactSystem.self)?.remove(contact: TFContact(entityIdA: idA, entityIdB: idB))
    }

    private func setUpSystems() {
        systemManager.add(system: HealthSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: MovementSystem(entityManager: entityManager))
        systemManager.add(system: RemoveSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: SpawnSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ShootingSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: HomeSystem(entityManager: entityManager, eventManager: eventManager, gridDelegate: grid))
        systemManager.add(system: AiSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ContactSystem(entityManager: entityManager, eventManager: eventManager))

        // Temporary until we have different gamemodes
        systemManager.system(ofType: AiSystem.self)?.aiPlayers.append(.oppositePlayer)
    }

    private func setUpSelectionNode() {
        selectionNode.delegate = selectionNodeDelegate
        scene?.addChild(selectionNode)
        // Position unit selection node on the left side of the screen
        selectionNode.position = CGPoint(x: 500, y: selectionNode.height / 2)

        // Calculate vertical spacing between unit nodes
        var horizontalX = 10.0
        // Position unit nodes vertically aligned
        for unitNode in selectionNode.unitNodes {
            let horizontalSpacing = unitNode.frame.width
            unitNode.position = CGPoint(x: horizontalX,
                                        y: 0)
            horizontalX += horizontalSpacing
        }
    }
}

extension GameWorld: EventTarget {
    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }
}

extension GameWorld: Renderable {
    func entitiesToRender() -> [TFEntity] {
        entityManager.entities
    }
}
