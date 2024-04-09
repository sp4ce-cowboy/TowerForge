//
//  TFEntity.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class TFEntity: Collidable {
    let id: UUID
    private(set) var components: [TFComponentType: TFComponent]

    init(id: UUID = UUID()) {
        self.id = id
        components = Dictionary()
    }

    func component<T: TFComponent>(ofType type: TFComponentType) -> T? {
        if let component = components[type] as? T {
            return component
        }
        
        return nil
    }

    func hasComponent(ofType type: TFComponentType) -> Bool {
        self.component(ofType: type) != nil
    }

    func addComponent<T: TFComponent>(_ component: T) {
        /// assert(checkRepresentation())
        guard !hasComponent(ofType: component.componentType) else {
            return
        }
        component.didAddToEntity(self)
        components[component.componentType] = component
    }

    func removeComponent(ofType type: TFComponentType) {
        /// assert(checkRepresentation())
        guard let componentToBeRemoved = component(ofType: type) else {
            return
        }
        componentToBeRemoved.willRemoveFromEntity()
        components.removeValue(forKey: componentToBeRemoved.componentType)
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
        for (key, _) in components where key != components[key]?.componentType {
                return false
        }
        return true
    }
}
