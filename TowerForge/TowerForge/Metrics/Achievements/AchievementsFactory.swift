//
//  AchievementsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

class AchievementsFactory {

    static var availableAchievementTypes: [String: Achievement.Type] =
        [
            String(describing: FiftyKillsAchievement.self): FiftyKillsAchievement.self,
            String(describing: HundredKillsAchievement.self): HundredKillsAchievement.self,
            String(describing: CenturionAchievement.self): CenturionAchievement.self
        ]

    static func registerAchievementType<T: Achievement>(_ stat: T) {
        availableAchievementTypes[String(describing: T.self)] = T.self
    }

    static func getDefaultAchievementsDatabase() -> AchievementsDatabase {
        let achievementsDatabase = AchievementsDatabase()
        availableAchievementTypes.values.forEach { achievementsDatabase.addAchievement(for: $0.asType) }
        return achievementsDatabase
    }

    static func createDefaultInstance(of typeName: String, with db: StatisticsDatabase) -> Achievement? {
        guard let type = availableAchievementTypes[typeName] else {
            return nil
        }
        return type.init(permanentValue: permanentValue, currentValue: currentValue)
    }
}
