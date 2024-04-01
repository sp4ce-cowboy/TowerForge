//
//  AchievementStorage.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// A class to encapsulate the storing of Achievements
final class AchievementStorage: Storage {

    override init(storageName: StorageEnums.StorageType = .achievementStorage,
                  objects: [UUID: any Storable] = [:]) {
        super.init(storageName: storageName, objects: objects)
    }

    required init(from decoder: any Decoder) throws {
        try super.init(from: decoder)
    }

    /// Adds storable if it doesn't exists and updates it if it does
    func addStorable(_ storable: Achievement) {
        storedObjects[storable.storableId] = storable
    }

    /// Removes a storable value if it exists
    func removeStorable(_ storable: Achievement) {
        storedObjects.removeValue(forKey: storable.storableId)
    }
}
