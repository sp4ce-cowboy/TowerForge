//
//  EntityManager.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class EntityManager {
    private var entitiesMap: [UUID: TFEntity]
    private var componentsMap: [TFComponentTypeWrapper: [UUID: TFEntity]]

    init() {
        entitiesMap = [:]
        componentsMap = [:]
    }

    var entities: [TFEntity] {
        Array(entitiesMap.values)
    }

    func entity(with id: UUID) -> TFEntity? {
        entitiesMap[id]
    }

    func add(_ entity: TFEntity) {
        entitiesMap[entity.id] = entity
        for (key, _) in entity.components {
            if componentsMap[key] == nil {
                componentsMap[key] = [:]
            }
            componentsMap[key]?[entity.id] = entity
        }
        /// assert(checkRepresentation())
    }

    func removeEntity(with id: UUID) -> Bool {
        guard let entity = entitiesMap.removeValue(forKey: id) else {
            return false
        }

        for (key, _) in entity.components {
            componentsMap[key]?.removeValue(forKey: entity.id)
        }
        return true
        /// assert(checkRepresentation())
    }

    func entities<T: TFComponent>(with componentType: T.Type) -> [TFEntity] {
        guard let entityMap = componentsMap[TFComponentTypeWrapper(type: componentType)] else {
            return []
        }

        return Array(entityMap.values)
    }

    func component<T: TFComponent>(ofType type: T.Type, of entityId: UUID) -> T? {
        guard let entity = entity(with: entityId) else {
            return nil
        }

        return entity.component(ofType: type)
    }

    func components<T: TFComponent>(ofType type: T.Type) -> [T] {
        /// assert(checkRepresentation())
        let typeWrapper = TFComponentTypeWrapper(type: type)
        return componentsMap[typeWrapper]?.compactMap({ $0.value.component(ofType: type) }) ?? []
    }

    /// Ensures that the UUID keys of entries in the dictionary match the UUID id of
    /// the associated values
    private func checkRepresentation() -> Bool {
        for (key, _) in entitiesMap where key != entitiesMap[key]?.id {
                return false
        }
        return true
    }
}
