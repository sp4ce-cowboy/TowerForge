//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storage class encapsulates a collection of unique Storables
class Storage: Codable {

    var storageName: TFStorageType
    var storedObjects: [TFStorableType: Storable]

    init(storageName: TFStorageType, objects: [TFStorableType: Storable] = [:]) {
        self.storageName = storageName
        self.storedObjects = objects
    }

    /// Adds storable if it doesn't exists and updates it if it does
    func addStorable(_ storable: Storable) {
        storedObjects[storable.storableName] = storable
    }

    /// Removes a storable value if it exists
    func removeStorable(_ storable: Storable) {
        storedObjects.removeValue(forKey: storable.storableName)
    }

    func getStorable(_ storableType: TFStorableType) -> Storable? {
        storedObjects[storableType]
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StorageEnums.StorageCodingKeys.self)
        try container.encode(storageName, forKey: .storageName)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .storedObjects)
        try storedObjects.values.forEach { try objectsContainer.encode($0) }
    }

    required init(from decoder: any Decoder) throws {
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

        self.storageName = name
        self.storedObjects = storedObjectsMap
    }

    private static func decodeElement(_ filesDict: KeyedDecodingContainer<StorageEnums.StorableDefaultCodingKeys>)
    throws -> (any Storable)? {

        let id = try filesDict.decode(UUID.self, forKey: .storableId)
        let storableName = try filesDict.decode(TFStorableType.self, forKey: .storableName)
        let storableValue = try filesDict.decode(Double.self, forKey: .storableValue)

        let storableObject = ObjectSet.fullStorableCreation[storableName]?(id, storableName, storableValue)
        return storableObject
    }

    private static func generateStoredObjectsCollection(_ storedObjects: [any Storable]) -> [TFStorableType: any Storable] {
        var storedObjectsMap: [TFStorableType: any Storable] = [:]

        for storable in storedObjects {
            storedObjectsMap[storable.storableName] = storable
        }

        return storedObjectsMap
    }

}
