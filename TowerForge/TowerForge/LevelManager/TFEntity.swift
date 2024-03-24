//
//  TFEntity.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class TFEntity: Collidable {
    let id: UUID
    private(set) var components: [UUID: TFComponent]

    init() {
        id = UUID()
        components = Dictionary()
    }

    func component<T: TFComponent>(ofType type: T.Type) -> T? {
        for component in components.values {
            guard let component = component as? T else {
                continue
            }
            return component
        }
        return nil
    }

    func hasComponent<T: TFComponent>(ofType type: T.Type) -> Bool {
        self.component(ofType: type) != nil
    }

    func addComponent<T: TFComponent>(_ component: T) {
        /// assert(checkRepresentation())
        guard !hasComponent(ofType: type(of: component)) else {
            return
        }
        component.didAddToEntity(self)
        components[component.id] = (component)
    }

    func removeComponent<T: TFComponent>(ofType type: T.Type) {
        /// assert(checkRepresentation())
        guard let componentToBeRemoved = component(ofType: type.self) else {
            return
        }
        componentToBeRemoved.willRemoveFromEntity()
        components.removeValue(forKey: componentToBeRemoved.id)
    }

    // To be overriden by sub classes as needed
    func collide(with other: any Collidable) -> TFEvent? {
        /// assert(checkRepresentation())
        nil
    }

    func collide(with damageComponent: DamageComponent) -> TFEvent? {
        /// assert(checkRepresentation())
        nil
    }

    func collide(with healthComponent: HealthComponent) -> TFEvent? {
        /// assert(checkRepresentation())
        nil
    }

    func collide(with movableComponent: MovableComponent) -> TFEvent? {
        /// assert(checkRepresentation())
        nil
    }

    /// Ensures that the UUID keys of entries in the dictionary match the UUID id of
    /// the associated values
    private func checkRepresentation() -> Bool {
        for (key, value) in components {
            if key != components[key]?.id {
                return false
            }
        }

        return true
    }
}
