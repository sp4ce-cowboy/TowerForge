import Foundation

class SpawnSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    /// Spawns the provided entity
    /// - Parameter entity: The TFEntity to be spawned
    func handleSpawn(with entity: TFEntity) {
        entityManager.add(entity)
    }
}
