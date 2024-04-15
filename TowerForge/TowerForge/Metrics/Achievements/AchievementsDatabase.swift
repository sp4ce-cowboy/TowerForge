//
//  AchievementsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

class AchievementsDatabase {
    weak var achievementsDataDelegate: AchievementsDataDelegate?
    var achievements: [AchievementTypeWrapper: Achievement] = [:]

    init(achievements: [AchievementTypeWrapper: Achievement] = [:]) {
        self.achievements = achievements
    }

    func addAchievement(for name: AchievementTypeWrapper) {
        if let stats = achievementsDataDelegate?.statisticsDatabase {
            achievements[name] = AchievementsFactory.createDefaultInstance(of: name.asString, with: stats)
        }
    }

    func getAchievement(for name: AchievementTypeWrapper) -> Achievement? {
        achievements[name]
    }

    func setToDefault() {
        achievements = AchievementsFactory.getDefaultAchievementsDatabase(achievementsDataDelegate).achievements
    }

    func updateAll(with stats: StatisticsDatabase) {
        achievements.values.forEach { $0.update(with: stats) }
    }

}
