//
//  GameEngine.swift
//  TowerForge
//
//  Created by Rubesh on 25/3/24.
//

import Foundation

protocol GameEngineDelegate: AnyObject {
    func onGameCompleted(gameState: GameState, gameResults: [GameResult])
}

/// The AbstractGameEngine defines the interface specifications between any concrete
/// implementation of a GameEngine and a client that requires a GameEngine. This is
/// is line with both the Interface Segregation Principle and the Dependency Inversion
/// Principle.
///
/// Where necessary, an appropriate GameEngine stub can be used to replace GameEngine
/// wherever it is required.
protocol AbstractGameEngine: EventTarget {
    var delegate: GameEngineDelegate? { get set }
    var entities: [TFEntity] { get }
    var eventManager: EventManager { get }
    var gameMode: GameMode { get }

    func updateGame(deltaTime: TimeInterval)
    func checkGameEnded() -> Bool
    func setUpSystems(with grid: Grid, and statsEngine: StatisticsEngine)

    func addEntity(_ entity: TFEntity)
    func addEvent(_ event: TFEvent)
    func addRemoteEvent(_ remoteEvent: TFRemoteEvent)

    func system<T: TFSystem>(ofType type: T.Type) -> T?
    func entities<T: TFComponent>(with componentType: T.Type) -> [TFEntity]
}

/// A class that encapsulates handling of all Managers.
///
/// Currently, as per the ECS specification, this includes SystemManager,
/// EntityManager, and EventManager.
///
/// A concrete implementation of the AbstractGameEngine protocol
class GameEngine: AbstractGameEngine {
    /// TODO: privatize these attributes after unit testing for private attibutes is sorted out
    var delegate: GameEngineDelegate?
    var entityManager: EntityManager
    var systemManager: SystemManager
    var eventManager: EventManager
    var gameMode: GameMode

    var entities: [TFEntity] { entityManager.entities }

    init(gameMode: Mode,
         entityManager: EntityManager = EntityManager(),
         systemManager: SystemManager = SystemManager(),
         roomId: RoomId? = nil, isHost: Bool = true, currentPlayer: GamePlayer? = nil) {
        self.entityManager = entityManager
        self.systemManager = systemManager
        self.eventManager = EventManager(roomId: roomId, isHost: isHost, currentPlayer: currentPlayer)
        self.gameMode = GameModeFactory.createGameMode(mode: gameMode, eventManager: eventManager)
        self.setupTeam()
        self.setupGame()
        self.setUpPlayerInfo(mode: self.gameMode)
    }

    init(gameMode: Mode,
         eventManager: EventManager,
         entityManager: EntityManager = EntityManager(),
         systemManager: SystemManager = SystemManager()) {
        self.entityManager = entityManager
        self.systemManager = systemManager
        self.eventManager = eventManager
        self.gameMode = GameModeFactory.createGameMode(mode: gameMode, eventManager: eventManager)
        self.setupTeam()
        self.setupGame()
        self.setUpPlayerInfo(mode: self.gameMode)
    }

    func updateGame(deltaTime: TimeInterval) {
        systemManager.update(deltaTime)
        eventManager.executeEvents(in: self)
        gameMode.updateGame(deltaTime: deltaTime)
        if checkGameEnded() {
            delegate?.onGameCompleted(gameState: gameMode.gameState, gameResults: gameMode.getGameResults())
        }
    }

    func checkGameEnded() -> Bool {
        gameMode.gameState == .WIN || gameMode.gameState == .LOSE || gameMode.gameState == .DRAW
    }

    func system<T: TFSystem>(ofType type: T.Type) -> T? {
        systemManager.system(ofType: type)
    }

    func entities<T: TFComponent>(with componentType: T.Type) -> [TFEntity] {
        entityManager.entities(with: componentType)
    }

    private func setupTeam() {
        let ownTeam = Team(player: .ownPlayer)
        let oppositeTeam = Team(player: .oppositePlayer)
        entityManager.add(ownTeam)
        entityManager.add(oppositeTeam)
    }

    /// Add game start event to trigger the total games statistic
    private func setupGame() {
        addEvent(GameStartEvent())
    }

    private func setUpPlayerInfo(mode: GameMode) {
        for prop in mode.gameProps {
            let hudEntity = prop.renderableEntity
            entityManager.add(hudEntity)
        }
    }

    func setUpSystems(with grid: Grid, and statsEngine: StatisticsEngine) {
        systemManager.add(system: HealthSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: MovementSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: PositionSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: RemoveSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: SpawnSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ShootingSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: TimerSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: ContactSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.add(system: HomeSystem(entityManager: entityManager, eventManager: eventManager,
                                             gridDelegate: grid))
        systemManager.add(system: StatisticSystem(entityManager: entityManager,
                                                  eventManager: eventManager, statsEngine: statsEngine))

        guard eventManager.remoteEventManager == nil else {
            return
        }
        systemManager.add(system: AiSystem(entityManager: entityManager, eventManager: eventManager))
        systemManager.system(ofType: AiSystem.self)?.aiPlayers.append(.oppositePlayer)
    }

    func addEntity(_ entity: TFEntity) {
        entityManager.add(entity)
    }

    func addEvent(_ event: TFEvent) {
        eventManager.add(event)
    }

    func addRemoteEvent(_ remoteEvent: TFRemoteEvent) {
        eventManager.add(remoteEvent)
    }

    func concede(player: Player) {
        gameMode.gameState = player == .ownPlayer ? .LOSE : .WIN
    }
}
