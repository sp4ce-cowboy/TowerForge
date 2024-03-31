//
//  Database.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// An Abstract data type to store a collection of Storages.
final class Database: Codable {

    var storedData: [TFStorageType: any Storage] = [:]

    init(storedData: [TFStorageType: any Storage] = [:]) {
        self.storedData = storedData
    }

    static func generateStorageCollection(_ storageObjects: [any Storage]) -> [TFStorageType: any Storage] {
        var storagesMap: [TFStorageType: any Storage] = [:]

        for storage in storageObjects {
            storagesMap[storage.storageName] = storage
        }

        return storagesMap
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StorageEnums.DatabaseCodingKeys.self)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .storedData)
        try storedData.values.forEach { try objectsContainer.encode($0) }
    }

    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: StorageEnums.DatabaseCodingKeys.self)
        var storageArrayForType = try container.nestedUnkeyedContainer(forKey: .storedData)
        var storages: [Storage] = []

        while !storageArrayForType.isAtEnd {
            let currentStorage = try storageArrayForType
                .nestedContainer(keyedBy: StorageEnums.StorageCodingKeys.self)
        }
    }

    private static func decodeStorage(_ storageDict: KeyedDecodingContainer<StorageEnums.StorageCodingKeys>)
    throws -> (any Storage)? {

        let storageName = try storageDict.decode(TFStorageType.self, forKey: .storageName)
        let storedObjects = try storageDict.decode([UUID: Storable].self, forKey: .storedObjects)

        let storableObject = ObjectSet.fullStorageCreation[storableName]?(storageName, storedObjects)
        return storableObject
    }
    
}
