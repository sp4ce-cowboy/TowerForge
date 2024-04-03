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
        guard let achievementStorage = StorageManager
            .getStorage(for: .achievementStorage) as? AchievementStorage else {

            return
        }

        // Retrieve the specific TotalGamesAchievement
        if let totalGamesAchievement = achievementStorage.storedObjects
            .first(where: { $0.value is TotalGamesAchievement })?
            .value as? TotalGamesAchievement {

            totalGamesAchievement.incrementGameCount()
            StorageManager.shared.saveToFile()
        } else {
            let newAchievement = TotalGamesAchievement() // Create if total games achievement doesn't already exist
            newAchievement.incrementGameCount()
            achievementStorage.storedObjects[newAchievement.storableName] = newAchievement
            StorageManager.shared.saveToFile()
        }
    }

    static func incrementTotalKillCount() {
        guard let achievementStorage = StorageManager
            .getStorage(for: .achievementStorage) as? AchievementStorage else {
            return
        }

        // Retrieve the specific total kill count achievement
        if let killAchievement = achievementStorage.storedObjects
            .first(where: { $0.value is TotalKillsAchievement })?
            .value as? TotalKillsAchievement {

            killAchievement.incrementKillCount()
            StorageManager.shared.saveToFile()
        } else {
            let newAchievement = TotalKillsAchievement() // Create if total kills achievement doesn't already exist
            newAchievement.incrementKillCount()
            achievementStorage.storedObjects[newAchievement.storableName] = newAchievement
            StorageManager.shared.saveToFile()
        }
    }
}
