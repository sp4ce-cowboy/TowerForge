import Foundation

class SpawnSystem: TFSystem {
    var isActive = false
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {

    }

    func handleSpawn(with entity: TFEntity) {
        entityManager?.add(entity)
    }

}
