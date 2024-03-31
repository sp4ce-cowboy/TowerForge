//
//  AchievementStorage.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// A class to encapsulate the storing of Achievements

final class AchievementStorage: Storage {

    var storageName: StorageEnums.StorageType = .achievementStorage
    var storedObjects: [UUID: Storable] = [:]

    init(storageName: StorageEnums.StorageType = .achievementStorage,
         files: [UUID: Storable] = [:]) {
        self.storageName = storageName
        self.storedObjects = files
    }
}

extension AchievementStorage {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StorageEnums.StorageCodingKeys.self)
        try container.encode(storageName, forKey: .storageName)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .storedFiles)
        try storedObjects.values.forEach { try objectsContainer.encode($0) }
    }

    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: StorageEnums.StorageCodingKeys.self)
        let name = try container.decode(StorageEnums.StorageType.self, forKey: .storageName)
        var elementsArrayForType = try container.nestedUnkeyedContainer(forKey: .storedFiles)
        var elements: [Storable] = []

        while !elementsArrayForType.isAtEnd {
            let filesDict = try elementsArrayForType
                .nestedContainer(keyedBy: StorageEnums.StorableDefaultCodingKeys.self)

            if let fileElement = try AchievementStorage.decodeElement(filesDict) {
                elements.append(fileElement)
            }
        }

        let storedObjectsMap = StorageManager.generateStoredObjectsCollection(elements)

        self.init(storageName: name, files: storedObjectsMap)
    }

    private static func decodeElement(_ filesDict: KeyedDecodingContainer<StorageEnums.StorableDefaultCodingKeys>)
    throws -> (any Storable)? {

        let id = try filesDict.decode(UUID.self, forKey: .storableId)
        let storableName = try filesDict.decode(TFStorableType.self, forKey: .storableName)
        let storableValue = try filesDict.decode(Double.self, forKey: .storableValue)

        let storableObject = ObjectSet.fullAchievementCreation[storableName]?(id, storableName, storableValue)
        return storableObject
    }
}
