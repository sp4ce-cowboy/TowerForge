import QuartzCore

class HealthSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    /// Modifies the health of the entity associated with the specified UUID according
    /// to the provided healthpoints amount.
    /// - Parameters:
    ///   - entityId: UUID of the entity whose health component is to be modified
    ///   - hp: Value of the required adjustment of health. Can be positive or negative.
    func modifyHealth(for entityId: UUID, with hp: CGFloat) {
        /*guard isActive else { TODO: Implement boolean check
            return
        }*/
        guard let currentEntity = entityManager.entity(with: entityId),
              let healthComponent = currentEntity.component(ofType: HealthComponent.self),
              let playerComponent = currentEntity.component(ofType: PlayerComponent.self) else {
            return
        }

        healthComponent.adjustHealth(amount: hp)

        if healthComponent.currentHealth <= 0 {
            eventManager.add(KillEvent(on: currentEntity.id, at: CACurrentMediaTime(), player: playerComponent.player))
        }
    }
}
