//
//  TFEntity.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class TFEntity: Collidable {
    let id: UUID
    private(set) var components: [TFComponentTypeWrapper: TFComponent]

    init(id: UUID = UUID()) {
        self.id = id
        components = Dictionary()
    }

    func component<T: TFComponent>(ofType type: T.Type) -> T? {
        let typeWrapper = TFComponentTypeWrapper(type: type)
        return components[typeWrapper] as? T
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
        let typeWrapper = TFComponentTypeWrapper(type: type(of: component))
        components[typeWrapper] = component
    }

    func removeComponent<T: TFComponent>(ofType type: T.Type) {
        /// assert(checkRepresentation())
        guard let componentToBeRemoved = component(ofType: type.self) else {
            return
        }
        componentToBeRemoved.willRemoveFromEntity()
        let typeWrapper = TFComponentTypeWrapper(type: type)
        components.removeValue(forKey: typeWrapper)
    }

    // To be overriden by sub classes as needed
    func collide(with other: any Collidable) -> TFEvent {
        /// assert(checkRepresentation())
        DisabledEvent()
    }

    func onSeparate() {}

    func collide(with damageComponent: DamageComponent) -> TFEvent {
        /// assert(checkRepresentation())
        DisabledEvent()
    }

    func collide(with healthComponent: HealthComponent) -> TFEvent {
        /// assert(checkRepresentation())
        DisabledEvent()
    }

    func collide(with movableComponent: MovableComponent) -> TFEvent {
        /// assert(checkRepresentation())
        DisabledEvent()
    }

    func collide(with playerComponent: PlayerComponent) -> TFEvent {
        /// assert(checkRepresentation())
        DisabledEvent()
    }

    /// Ensures that the UUID keys of entries in the dictionary match the UUID id of
    /// the associated values
    private func checkRepresentation() -> Bool {
        for (key, _) in components where type(of: components[key]) == key.type {
            return false
        }
        return true
    }
}
