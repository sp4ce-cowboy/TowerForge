//
//  ObjectSet.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// A utility class that allows for
class ObjectSet {

    /// A dictionary of available Achievement types and closures that create full instances of them
    static var fullStorableCreation: [TFStorableType: (UUID, TFStorableType, Double) -> any Storable] = [
        .killAchievement: { id, type, value in KillAchievement(id: id, name: type, value: value) },
        .totalGamesAchievement: { id, type, value in TotalGamesAchievement(id: id, name: type, value: value) }
    ]

    static var fullStorageCreation: [TFStorageType: (TFStorageType, [UUID: Storable]) -> any Storage] = [
        .achievementStorage: { type, objects in AchievementStorage(storageName: type, objects: objects) }
    ]
}
