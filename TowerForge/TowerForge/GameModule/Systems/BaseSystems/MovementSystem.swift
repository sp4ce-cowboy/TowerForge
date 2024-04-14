import Foundation

class MovementSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        entityManager.components(ofType: MovableComponent.self).forEach({
            self.processMovableComponent($0, time: time)
        })
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

    private func processMovableComponent(_ movableComponent: MovableComponent, time: CGFloat) {
        guard movableComponent.shouldMove, let entity = movableComponent.entity,
              let player = entity.component(ofType: PlayerComponent.self)?.player else {
            return
        }

        if entity is BaseProjectile {
            movableComponent.update(deltaTime: time)
            return
        }

        guard eventManager.isHost else {
            return
        }

        let displacement = movableComponent.velocity * player.getDirectionVelocity() * time
        guard let player = eventManager.currentPlayer else {
            eventManager.add(MoveEvent(on: entity.id, at: Date().timeIntervalSince1970, with: displacement))
            return
        }
        eventManager.add(RemoteMoveEvent(id: entity.id, moveBy: displacement, gamePlayer: player))
    }
}
