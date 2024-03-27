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
    var eventManager: EventManager { get }

    func updateGame(deltaTime: TimeInterval)
    func setUpSystems(with grid: Grid)
    func setUpPlayerInfo(mode: GameMode)

    func addEntity(_ entity: TFEntity)
    func addEvent(_ event: TFEvent)

    func system<T: TFSystem>(ofType type: T.Type) -> T?
}

/// A class that encapsulates handling of all Managers.
///
/// Currently, as per the ECS specification, this includes SystemManager,
/// EntityManager, and EventManager.
///
/// A concrete implementation of the AbstractGameEngine protocol
class GameEngine: AbstractGameEngine {

    /// TODO: privatize these attributes after unit testing for private attibutes is sorted out
    var entityManager: EntityManager
    var systemManager: SystemManager
    var eventManager: EventManager

    var entities: [TFEntity] { entityManager.entities }

    init(entityManager: EntityManager = EntityManager(),
         systemManager: SystemManager = SystemManager(),
         eventManager: EventManager = EventManager()) {
        self.entityManager = entityManager
        self.systemManager = systemManager
        self.eventManager = eventManager
        self.setupTeam()
    }

    func updateGame(deltaTime: TimeInterval) {
        systemManager.update(deltaTime)
        eventManager.executeEvents(in: self)
    }

    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }

    private func setupTeam() {
        let ownTeam = Team(player: .ownPlayer)
        let oppositeTeam = Team(player: .oppositePlayer)
        entityManager.add(ownTeam)
        entityManager.add(oppositeTeam)
    }

    func setUpPlayerInfo(mode: GameMode) {
        for prop in mode.gameProps {
            let hudEntity = prop.renderableEntity
            entityManager.add(hudEntity)
        }
    }

    func setUpSystems(with grid: Grid) {
        systemManager.add(system: HealthSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: MovementSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: PositionSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: RemoveSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: SpawnSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ShootingSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: AiSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: TimerSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ContactSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: HomeSystem(entityManager: entityManager, eventManager: eventManager,
                                             gridDelegate: grid))

        // Temporary until we have different gamemodes
        systemManager.system(ofType: AiSystem.self)?.aiPlayers.append(.oppositePlayer)

    }

    func addEntity(_ entity: TFEntity) {
        entityManager.add(entity)
    }

    func addEvent(_ event: TFEvent) {
        eventManager.add(event)
    }
}
