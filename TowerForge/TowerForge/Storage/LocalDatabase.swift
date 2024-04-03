//
//  Database.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// An Abstract data type to store a collection of Storages.
final class LocalDatabase: Codable {

    var storedData: [TFStorageType: Storage] = [:]

    init(storedData: [TFStorageType: Storage] = [:]) {
        self.storedData = storedData
    }

    static func generateStorageCollection(_ storageObjects: [Storage]) -> [TFStorageType: Storage] {
        var storagesMap: [TFStorageType: Storage] = [:]
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StorageEnums.DatabaseCodingKeys.self)
        let storagesContainer = try container.nestedContainer(keyedBy: TFStorageType.self, forKey: .storedData)
        var tempStoredData: [TFStorageType: Storage] = [:]

        for key in storagesContainer.allKeys {
            let storage = try storagesContainer.decode(Storage.self, forKey: key)
            let storageObject = ObjectSet.fullStorageCreation[key]?(storage)
            tempStoredData[key] = storageObject
        }

        self.storedData = tempStoredData
    }
}
