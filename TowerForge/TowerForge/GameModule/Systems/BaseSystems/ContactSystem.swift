//
//  ContactSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import Foundation

class ContactSystem: TFSystem {
    var isActive = true
    weak var entityManager: EntityManager?
    weak var eventManager: EventManager?

    private var contacts: Set<TFContact> = []

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        for contact in contacts {
            handleContact(between: contact.entityIdA, and: contact.entityIdB)
        }
    }

    func insert(contact: TFContact) {
        guard contact.entityIdA != contact.entityIdB, entityManager?.entity(with: contact.entityIdA) != nil,
              entityManager?.entity(with: contact.entityIdB) != nil else {
            return
        }
        contacts.insert(contact)
    }

    func remove(contact: TFContact) {
        if contacts.remove(contact) != nil {
            handleSeparation(between: contact.entityIdA, and: contact.entityIdB)
        }
    }

    private func handleContact(between idA: UUID, and idB: UUID) {
        guard let entityA = entityManager?.entity(with: idA), let entityB = entityManager?.entity(with: idB) else {
            contacts.remove(TFContact(entityIdA: idA, entityIdB: idB))
            handleSeparation(between: idA, and: idB)
            return
        }

        guard let event = entityA.collide(with: entityB) else {
            return
        }

        eventManager?.add(event)
    }

    private func handleSeparation(between idA: UUID, and idB: UUID) {
        if let entityA = entityManager?.entity(with: idA),
           let movableComponent = entityA.component(ofType: MovableComponent.self) {
            movableComponent.isColliding = false
        }

        if let entityB = entityManager?.entity(with: idB),
           let movableComponent = entityB.component(ofType: MovableComponent.self) {
            movableComponent.isColliding = false
        }
    }
}
