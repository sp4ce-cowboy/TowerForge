import Foundation

class RemoveSystem: TFSystem {
    var isActive = true
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    /// Removes the provided entity
    /// - Parameter entityId: The UUID of the associated TFEntity to be removed
    func handleRemove(for entityId: UUID) {
        entityManager?.removeEntity(with: entityId)
    }
}
