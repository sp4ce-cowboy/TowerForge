//
//  GameWorld.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation

class GameWorld {
    private unowned var scene: GameScene?
    private var entityManager: EntityManager
    private var systemManager: SystemManager
    private var eventManager: EventManager
    private var selectionNode: UnitSelectionNode
    private var grid: Grid
    private var renderer: Renderer?

    init(scene: GameScene?, screenSize: CGRect) {
        self.scene = scene
        entityManager = EntityManager()
        systemManager = SystemManager()
        eventManager = EventManager()
        selectionNode = UnitSelectionNode()
        grid = Grid(eventManager: eventManager, screenSize: screenSize)
        if let scene = self.scene {
            grid.generateTileMap(scene: scene)
        }
        renderer = Renderer(target: self, scene: scene)

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
    }
    // TODO: Move contact handling to a system
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
        systemManager.add(system: HomeSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: AiSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ContactSystem(entityManager: entityManager, eventManager: eventManager))

        // Temporary until we have different gamemodes
        systemManager.system(ofType: AiSystem.self)?.aiPlayers.append(.oppositePlayer)
    }

    private func setUpSelectionNode() {
        selectionNode.delegate = grid
        scene?.addChild(selectionNode)
        // Position unit selection node on the left side of the screen
        selectionNode.position = CGPoint(x: selectionNode.frame.width / 2, y: scene?.frame.midY ?? 300)

        // Calculate vertical spacing between unit nodes
        let verticalSpacing = selectionNode.frame.height
        var verticalY = 10.0
        // Position unit nodes vertically aligned
        for unitNode in selectionNode.unitNodes {
            unitNode.position = CGPoint(x: selectionNode.frame.width / 2,
                                        y: verticalY)
            verticalY += verticalSpacing
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
