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

}
