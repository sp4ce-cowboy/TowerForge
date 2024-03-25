//
//  GameEngine.swift
//  TowerForge
//
//  Created by Rubesh on 25/3/24.
//

import Foundation

/// The AbstractGameEngine defines the interface specifications between any concrete
/// implementation of a GameEngine and a client that requires a GameEngine. This is
/// is line with both the Interface Segregation Principle and the Dependency Inversion
/// Principle.
///
/// Where necessary, an appropriate GameEngine stub can be used to replace GameEngine
/// wherever it is required.
protocol AbstractGameEngine: EventTarget {
    var entities: [TFEntity] { get }

    func updateGame(deltaTime: TimeInterval)
    func setUpSystems(with grid: Grid)

    func contactDidBegin(between idA: UUID, and idB: UUID)
    func contactDidEnd(between idA: UUID, and idB: UUID)

    func addEntity(_ entity: TFEntity)
    func addEvent(_ event: TFEvent)

    func system<T: TFSystem>(ofType type: T.Type) -> T?
}

extension GameEngine {
    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }
}

/// A class that encapsulates handling of all Managers.
///
/// Currently, as per the ECS specification, this includes SystemManager,
/// EntityManager, and EventManager.
///
/// A concrete implementation of the AbstractGameEngine protocol
class GameEngine: AbstractGameEngine {
    private var entityManager: EntityManager
    private var systemManager: SystemManager
    private var eventManager: EventManager

    var entities: [TFEntity] {
        entityManager.entities
    }

    init(entityManager: EntityManager = EntityManager(),
         systemManager: SystemManager = SystemManager(),
         eventManager: EventManager = EventManager()) {
        self.entityManager = entityManager
        self.systemManager = systemManager
        self.eventManager = eventManager
    }

    func updateGame(deltaTime: TimeInterval) {
        systemManager.update(deltaTime)
        eventManager.executeEvents(in: self)
        self.setupTeam()
        self.setupPlayerInfo()
    }

    private func setupTeam() {
        let ownTeam = Team(player: .ownPlayer)
        let oppositeTeam = Team(player: .oppositePlayer)
        entityManager.add(ownTeam)
        entityManager.add(oppositeTeam)
    }

    private func setupPlayerInfo() {
        let point = Point(initialPoint: 0)
        entityManager.add(point)

        let life = Life(initialLife: Team.lifeCount)
        entityManager.add(life)
    }

    func setUpSystems(with grid: Grid) {
        systemManager.add(system: HealthSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: MovementSystem(entityManager: entityManager))
        systemManager.add(system: RemoveSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: SpawnSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ShootingSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: AiSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ContactSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: HomeSystem(entityManager: entityManager, eventManager: eventManager,
                                             gridDelegate: grid))

        // Temporary until we have different gamemodes
        systemManager.system(ofType: AiSystem.self)?.aiPlayers.append(.oppositePlayer)
    }

    func contactDidBegin(between idA: UUID, and idB: UUID) {
        systemManager.system(ofType: ContactSystem.self)?.insert(contact: TFContact(entityIdA: idA, entityIdB: idB))
    }

    func contactDidEnd(between idA: UUID, and idB: UUID) {
        systemManager.system(ofType: ContactSystem.self)?.remove(contact: TFContact(entityIdA: idA, entityIdB: idB))
    }

    func addEntity(_ entity: TFEntity) {
        entityManager.add(entity)
    }

    func addEvent(_ event: TFEvent) {
        eventManager.add(event)
    }
}
