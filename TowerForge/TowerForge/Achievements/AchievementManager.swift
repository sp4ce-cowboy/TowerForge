//
//  AchievementManager.swift
//  TowerForge
//
//  Created by Rubesh on 1/4/24.
//

import Foundation

/// Utility class to encapsulate all the methods required for storing, loading and updating
/// achievements and their local storage.
class AchievementManager {

    /// TODO: Standardize this to make it more easily expandable to more achievements, maybe with ObjectSet also?
    static func incrementTotalGamesStarted() {
        // Retrieve the AchievementStorage from the Database
        if let achievementStorage = StorageManager.getStorage(for: .achievementStorage) as? AchievementStorage {

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

    func incrementTotalKillCount() {
        // Retrieve the AchievementStorage from the Database
        if let achievementStorage = StorageManager.getStorage(for: .achievementStorage) as? AchievementStorage {

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
