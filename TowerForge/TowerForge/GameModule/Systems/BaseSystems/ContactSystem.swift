//
//  ContactSystem.swift
//  TowerForge
//
//  Created by Zheng Ze on 23/3/24.
//

import Foundation

class ContactSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager
    private var contacts: Set<TFContact>

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
        self.contacts = []
    }

    func update(within time: CGFloat) {
        let contactComponents = entityManager.components(ofType: ContactComponent.self)
        var contactsToBeSeparated = contacts
        contacts = evaluate(contactComponents: contactComponents)

        for contact in contacts {
            contactsToBeSeparated.remove(contact)
        }

        for contact in contactsToBeSeparated {
            if let entityA = entityManager.entity(with: contact.entityIdA) {
                handleSeparation(for: entityA)
            }

            if let entityB = entityManager.entity(with: contact.entityIdB) {
                handleSeparation(for: entityB)
            }
        }

        for contact in contacts {
            guard let entityA = entityManager.entity(with: contact.entityIdA),
                  let entityB = entityManager.entity(with: contact.entityIdB) else {
                continue
            }
            handleContact(between: entityA, and: entityB)
        }
    }

    private func evaluate(contactComponents: [ContactComponent]) -> Set<TFContact> {
        var contacts: Set<TFContact> = []
        for i in 0..<contactComponents.count {
            let contactComponentA = contactComponents[i]
            guard let entityA = contactComponentA.entity,
                  let positionComponentA = entityA.component(ofType: PositionComponent.self) else {
                continue
            }

            for j in i + 1..<contactComponents.count {
                let contactComponentB = contactComponents[j]
                guard let entityB = contactComponentB.entity,
                      let positionComponentB = entityB.component(ofType: PositionComponent.self) else {
                    continue
                }

                let hitboxA = contactComponentA.hitbox(position: positionComponentA.position)
                let hitboxB = contactComponentB.hitbox(position: positionComponentB.position)

                if hitboxA.intersects(hitboxB) {
                    let contact = TFContact(entityIdA: entityA.id, entityIdB: entityB.id)
                    contacts.insert(contact)
                }
            }
        }
        return contacts
    }

    private func handleContact(between entityA: TFEntity, and entityB: TFEntity) {
        guard let event = entityA.collide(with: entityB) else {
            return
        }
        eventManager.add(event)
    }

    private func handleSeparation(for entity: TFEntity) {
        entity.onSeparate()
    }
}
