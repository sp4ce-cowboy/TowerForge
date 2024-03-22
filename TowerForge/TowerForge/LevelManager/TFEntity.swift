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
        guard !hasComponent(ofType: type(of: component)) else {
            return
        }
        component.didAddToEntity(self)
        components[component.id] = (component)
    }

    func removeComponent<T: TFComponent>(ofType type: T.Type) {
        guard let componentToBeRemoved = component(ofType: T.self) else {
            return
        }
        componentToBeRemoved.willRemoveFromEntity()
        components.removeValue(forKey: componentToBeRemoved.id)
    }

    // To be overriden by sub classes as needed
    func collide(with other: any Collidable) -> TFEvent? {
        nil
    }

    func collide(with damageComponent: DamageComponent) -> TFEvent? {
        nil
    }

    func collide(with healthComponent: HealthComponent) -> TFEvent? {
        nil
    }
}
