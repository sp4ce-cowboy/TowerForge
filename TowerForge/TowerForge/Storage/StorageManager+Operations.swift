//
//  StorageManager+Operations.swift
//  TowerForge
//
//  Created by Rubesh on 1/4/24.
//

import Foundation

/// This class contains utility methods for the StorageManager to handle
/// loading and storing of values
extension StorageManager {
    static func getStorage(for type: TFStorageType) -> Storage? {
        StorageManager.shared.storedDatabase.storedData[type]
    }

    func initializeDefaultAchievements() {
        if storedDatabase.storedData[.achievementStorage] == nil {
            let achievementStorage = AchievementStorage()

            // Iterate through all achievements and add them to the achievementStorage
            for achievementType in TFAchievementType.allCases {
                guard let defaultAchievement = ObjectSet.defaultAchievementCreation[achievementType]?() else {
                    continue
                }

                achievementStorage.addStorable(defaultAchievement)
            }
            // Store the AchievementStorage in the Database
            storedDatabase.storedData[.achievementStorage] = achievementStorage
            Logger.log("Default achievements initialized", self)
        }
    }
}
