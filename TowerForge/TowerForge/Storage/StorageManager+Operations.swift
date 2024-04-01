//
//  StorageManager+Operations.swift
//  TowerForge
//
//  Created by Rubesh on 1/4/24.
//

import Foundation

/// This class contains utility methods for the StorageManager to handle
/// loading and storing of default values.
extension StorageManager {
    func initializeDefaultAchievements() {
        // Check if the achievements are already loaded
        if storedData.storedData[.achievementStorage] == nil {
            // Initialize the storage for achievements if not present
            let achievementStorage = AchievementStorage()

            // Iterate through all achievements and add them to the achievementStorage
            for achievementType in TFAchievementType.allCases {
                guard let defaultAchievement = ObjectSet.defaultAchievementCreation[achievementType]?() else {
                    continue
                }
                achievementStorage.addStorable(defaultAchievement)
            }
            // Store the AchievementStorage in the Database
            storedData.storedData[.achievementStorage] = achievementStorage
        }
    }
}
