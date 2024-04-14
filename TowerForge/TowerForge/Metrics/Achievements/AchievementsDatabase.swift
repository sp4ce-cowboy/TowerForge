//
//  AchievementsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

class AchievementsDatabase {
    var achievements: [AchievementTypeWrapper: Achievement] = [:]

    init(achievements: [AchievementTypeWrapper: Achievement] = [:]) {
        self.achievements = achievements
    }

    func addAchievement(for name: AchievementTypeWrapper) {
        achievements[name] = name.type
    }

    func getAchievement(for name: AchievementTypeWrapper) -> Achievement? {
        achievements[name]
    }

    func setToDefault() {
        achievements = StatisticsFactory.getDefaultStatisticsDatabase().statistics
    }

    func updateAll(with stats: StatisticsDatabase) {
        achievements.values.forEach { $0.update(with: stats) }
    }

}
