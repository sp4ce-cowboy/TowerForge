//
//  AchievementsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

protocol AchievementsDataDelegate: AnyObject {
    var statisticsDatabase: StatisticsDatabase { get }
}

/// The AchievementsEngine is an InferenceEngine that interprets permanent
/// information received from the Statistics component.
///
/// It contains a Database of Achievements, and when notified by the StatisticsEngine,
/// will update all Achievements therein contained.
class AchievementsEngine: InferenceEngine, AchievementsDataDelegate {
    unowned var statisticsEngine: StatisticsEngine
    var achievementsDatabase: AchievementsDatabase
    var statisticsDatabase: StatisticsDatabase {
        statisticsEngine.statistics
    }

    init(_ statisticsEngine: StatisticsEngine) {
        self.statisticsEngine = statisticsEngine
        self.achievementsDatabase = AchievementsDatabase()
        achievementsDatabase.achievementsDataDelegate = self
    }

    func updateOnReceive() {
        achievementsDatabase.updateAll(with: statisticsEngine.statistics)
    }

}
