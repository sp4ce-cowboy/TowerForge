//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storage class encapsulates a specific type of Storable item.
/// It also enforces type consistency to ensure that only one type of
/// storable item type is contained within itself at all times.

protocol Storage: Codable {

    var storageName: TFStorageType { get set }
    var storedObjects: [UUID: Storable] { get set }

    init(storageName: TFStorageType, objects: [UUID: Storable])
}

/// Default implementation of 
extension Storage {

    static func generateStoredObjectsCollection(_ storedObjects: [any Storable]) -> [UUID: any Storable] {
        var storedObjectsMap: [UUID: any Storable] = [:]

        for storable in storedObjects {
            storedObjectsMap[storable.storableId] = storable
        }

        return storedObjectsMap
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StorageEnums.StorageCodingKeys.self)
        try container.encode(storageName, forKey: .storageName)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .storedObjects)
        try storedObjects.values.forEach { try objectsContainer.encode($0) }
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: StorageEnums.StorageCodingKeys.self)
        let name = try container.decode(StorageEnums.StorageType.self, forKey: .storageName)
        var elementsArrayForType = try container.nestedUnkeyedContainer(forKey: .storedObjects)
        var elements: [Storable] = []

        while !elementsArrayForType.isAtEnd {
            let filesDict = try elementsArrayForType
                .nestedContainer(keyedBy: StorageEnums.StorableDefaultCodingKeys.self)

            if let fileElement = try AchievementStorage.decodeElement(filesDict) {
                elements.append(fileElement)
            }
        }

        let storedObjectsMap = Self.generateStoredObjectsCollection(elements)

        self.init(storageName: name, files: storedObjectsMap)
    }

    private static func decodeElement(_ filesDict: KeyedDecodingContainer<StorageEnums.StorableDefaultCodingKeys>)
    throws -> (any Storable)? {

        let id = try filesDict.decode(UUID.self, forKey: .storableId)
        let storableName = try filesDict.decode(TFStorableType.self, forKey: .storableName)
        let storableValue = try filesDict.decode(Double.self, forKey: .storableValue)

        let storableObject = ObjectSet.fullStorableCreation[storableName]?(id, storableName, storableValue)
        return storableObject
    }
}
