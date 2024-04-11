//
//  TFComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

struct TFComponentTypeWrapper {
    let type: TFComponent.Type
}

extension TFComponentTypeWrapper: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

class TFComponent: Identifiable {
    var id = UUID()
    weak var entity: TFEntity?

    init() {
        // No initialisation logic needed as of now
    }

    func update(deltaTime: TimeInterval) {} // To be overriden by its inheriters

    // Notify when the component is added to an entity.
    // This reference provides components other access to components 
    // from the same entity, to allow collaboration in the ECS framework

    func didAddToEntity(_ entity: TFEntity) {
        self.entity = entity
    }

    func willRemoveFromEntity() {
        self.entity = nil
    }
}
