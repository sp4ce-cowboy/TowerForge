//
//  AchievementsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

/// The AchievementsEngine is an InferenceEngine that interprets permanent
/// information received from the Statistics component.
///
/// It contains a Database of Achievements, and when notified by the StatisticsEngine,
/// will update all Achievements therein contained.
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
