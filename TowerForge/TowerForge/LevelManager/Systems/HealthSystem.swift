import Foundation

class HealthSystem: TFSystem {
    var isActive = false
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {

    }

    func modifyHealth(for entityId: UUID, with hp: CGFloat) {
        guard let currentEntity = entityManager?.getEntity(with: entityId),
              let healthComponent = currentEntity.component(ofType: HealthComponent.self) else {
            return
        }

        healthComponent.decreaseHealth(amount: hp)
    }

}
