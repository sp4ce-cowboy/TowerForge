//
//  TFEntity.swift
//  TowerForge
//
//  Created by MacBook Pro on 14/03/24.
//

import Foundation

class TFEntity {
    let id: UUID
    private(set) var components: [String: TFComponent]

    init() {
        id = UUID()
        components = Dictionary()
    }

    func component<T: TFComponent>(ofType type: T.Type) -> T? {
        return components[String(describing: T.self)] as? T
    }

    func hasComponent<T: TFComponent>(ofType type: T.Type) -> Bool {
        self.component(ofType: type) != nil
    }

    func addComponent(_ component: TFComponent) {
        guard !hasComponent(ofType: type(of: component)) else {
            return
        }
        component.didAddToEntity(self)
        components[String(describing: type(of: component).self)] = (component)
    }

    func removeComponent<T: TFComponent>(ofType type: T.Type) {
        guard let componentToBeRemoved = component(ofType: T.self) else {
            return
        }
        componentToBeRemoved.willRemoveFromEntity()
        components.removeValue(forKey: String(describing: T.self))
    }
}
