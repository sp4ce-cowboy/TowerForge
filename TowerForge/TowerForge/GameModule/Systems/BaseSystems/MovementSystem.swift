import Foundation

class MovementSystem: TFSystem {
    private static let UPDATE_INTERVAL: TimeInterval = 0.1

    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    private var timeSinceLastUpdate: TimeInterval = .zero
    private var positionsMap: [UUID: CGPoint] = [:]

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        timeSinceLastUpdate += time

        let movableComponents = entityManager.components(ofType: MovableComponent.self)

        movableComponents.forEach({
            self.processMovableComponent($0, time: time)
        })

        if timeSinceLastUpdate >= MovementSystem.UPDATE_INTERVAL {
            syncLocations(with: positionsMap)
            positionsMap.removeAll(keepingCapacity: true)
            timeSinceLastUpdate = .zero
        }
    }

    /// Handles movement for the entity associated with the specified UUID according
    /// to the provided displacement vector.
    ///
    /// - Parameters:
    ///   - entityId: UUID of the entity that is to be moved
    ///   - displacement: Value of the required displacement
    func handleMovement(for entityId: UUID, with displacement: CGVector) {
        /*guard isActive else { TODO: Implement boolean check
         return
         }*/
        guard let currentEntity = entityManager.entity(with: entityId),
              let movementComponent = currentEntity.component(ofType: MovableComponent.self) else {
            return
        }

        movementComponent.updatePosition(with: displacement)
    }

    func updatePosition(for entityId: UUID, to position: CGPoint) {
        guard let currentEntity = entityManager.entity(with: entityId),
              let positionComponent = currentEntity.component(ofType: PositionComponent.self) else {
            return
        }

        positionComponent.changeTo(to: position)
    }

    private func processMovableComponent(_ movableComponent: MovableComponent, time: CGFloat) {

        guard movableComponent.shouldMove, let entity = movableComponent.entity,
              let player = entity.component(ofType: PlayerComponent.self)?.player else {
            return
        }

        let displacement = movableComponent.velocity * player.getDirectionVelocity() * time
        eventManager.add(MoveEvent(on: entity.id, at: Date().timeIntervalSince1970, with: displacement))

        if !(entity is BaseProjectile), eventManager.isHost, timeSinceLastUpdate >= MovementSystem.UPDATE_INTERVAL,
           let positionComponent = entity.component(ofType: PositionComponent.self) {
            positionsMap[entity.id] = positionComponent.position
        }
    }

    private func syncLocations(with positionsMap: [UUID: CGPoint]) {
        guard eventManager.isHost, let player = eventManager.currentPlayer, !positionsMap.isEmpty else {
            return
        }

        DispatchQueue.global().async {
            self.eventManager.add(RemoteSyncPositionEvent(positionMap: positionsMap, gamePlayer: player))
        }
    }
}
