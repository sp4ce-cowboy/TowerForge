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
                  objects: [UUID: Storable] = [:]) {
        super.init(storageName: storageName, objects: objects)
    }

    required init(from decoder: any Decoder) throws {
        try super.init(from: decoder)
    }
}
