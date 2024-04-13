//
//  AchievementsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class AchievementsEngine: InferenceEngine {

    var statisticsDatabase: StatisticsDatabase
    var achievementsDatabase = AchievementsDatabase()

    init(statisticsDatabase: StatisticsDatabase) {
        self.statisticsDatabase = statisticsDatabase
    }

    func updateOnReceive(stats: StatisticsDatabase) {
        statisticsDatabase = stats
    }

}
