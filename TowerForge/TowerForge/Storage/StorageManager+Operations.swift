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
    func getStorage(for type: TFStorageType) -> Storage? {
        storedDatabase.storedData[type]
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

    func incrementTotalGamesStarted() {
        // Retrieve the AchievementStorage from the Database
        if let achievementStorage = getStorage(for: .achievementStorage) as? AchievementStorage {

            // Retrieve the specific TotalGamesAchievement
            if let totalGamesAchievement = achievementStorage.storedObjects
                                            .first(where: { $0.value is TotalGamesAchievement })?
                                            .value as? TotalGamesAchievement {

                // Increment the game count
                totalGamesAchievement.incrementGameCount()

                // Save the updated database to file
                StorageManager.shared.saveToFile()
            } else {
                // If the achievement doesn't exist, create it and add it to the achivement storage
                let newAchievement = TotalGamesAchievement()
                newAchievement.incrementGameCount()
                achievementStorage.storedObjects[newAchievement.storableName] = newAchievement
                StorageManager.shared.saveToFile()
            }
        }
    }
}
