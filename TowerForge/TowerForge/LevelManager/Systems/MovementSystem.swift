import Foundation

class MovementSystem: TFSystem {
    var isActive = false
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        guard let entities = entityManager?.entities else {
            return
        }

        for entity in entities {
            let movableComponent = entity.component(ofType: MovableComponent.self)
            movableComponent?.update(deltaTime: time)
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
        guard let currentEntity = entityManager?.entity(with: entityId),
              let movementComponent = currentEntity.component(ofType: MovableComponent.self) else {
            return
        }

        movementComponent.updatePosition(with: displacement)
    }

}
