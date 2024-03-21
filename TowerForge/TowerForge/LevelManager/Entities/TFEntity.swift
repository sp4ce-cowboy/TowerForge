//
//  TFEntity.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class TFEntity {
    let id: UUID
    private(set) var components: Set<TFComponent> = []

    init() {
        id = UUID()
    }

    init(withId id: UUID) {
        self.id = id
    }

    func component<T: TFComponent>(ofType type: T.Type) -> T? {
        for component in components {
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
        components.insert(component)
    }

    /// Adds component if it does not exist and overrides if it does
    func updateComponent<T: TFComponent>(_ component: T) {
        components.update(with: component)
    }

    func removeComponent<T: TFComponent>(ofType type: T.Type) {
        guard let componentToBeRemoved = component(ofType: T.self) else {
            return
        }
        componentToBeRemoved.willRemoveFromEntity()
        components.remove(componentToBeRemoved)
    }
}
