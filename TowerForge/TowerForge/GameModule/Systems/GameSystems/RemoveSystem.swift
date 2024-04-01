import Foundation

class RemoveSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    /// Removes the provided entity
    /// - Parameter entityId: The UUID of the associated TFEntity to be removed
    func handleRemove(for entityId: UUID) {
        if entityManager.entity(with: entityId)?.component(ofType: PlayerComponent.self)?.player != .ownPlayer {
            AchievementManager.incrementTotalKillCount() // Increment if entity does not belong to own player
        }
        entityManager.removeEntity(with: entityId)
    }
}
