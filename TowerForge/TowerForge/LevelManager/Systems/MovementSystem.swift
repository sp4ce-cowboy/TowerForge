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

    }

    func handleMovement(for entityId: UUID, with displacement: CGVector) {
        guard let currentEntity = entityManager?.getEntity(with: entityId),
              let movementComponent = currentEntity.component(ofType: MovableComponent.self) else {
            return
        }

        movementComponent.updatePosition(with: displacement)
    }

}
