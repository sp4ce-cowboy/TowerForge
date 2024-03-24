//
//  EntityManager.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class EntityManager {
    private var entitiesMap: [UUID: TFEntity]

    init() {
        entitiesMap = Dictionary()
    }

    var entities: [TFEntity] {
        Array(entitiesMap.values)
    }

    func entity(with id: UUID) -> TFEntity? {
        entitiesMap[id]
    }

    func add(_ entity: TFEntity) {
        entitiesMap[entity.id] = entity
    }

    func removeEntity(with id: UUID) {
        entitiesMap.removeValue(forKey: id)
    }

    func component<T: TFComponent>(ofType type: T.Type, of entityId: UUID) -> T? {
        guard let entity = entity(with: entityId) else {
            return nil
        }

        return entity.component(ofType: type)
    }

    func components<T: TFComponent>(ofType type: T.Type) -> [T] {
        entities.compactMap { $0.component(ofType: type) }
    }
    
    /// Ensures that the UUID keys of entries in the dictionary match the UUID id of
    /// the associated values
    private func checkRepresentation() -> Bool {
        for (key, value) in entitiesMap {
            if key != components[key]?.id {
                return false
            }
        }
        
        return true
    }
}
