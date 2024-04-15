//
//  MissionsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

class MissionsEngine: InferenceEngine, InferenceDataDelegate {
    unowned var statisticsEngine: StatisticsEngine
    var missionsDatabase: MissionsDatabase
    var statisticsDatabase: StatisticsDatabase {
        statisticsEngine.statistics
    }

    init(_ statisticsEngine: StatisticsEngine) {
        self.statisticsEngine = statisticsEngine
        self.missionsDatabase = MissionsDatabase()
        missionsDatabase.missionsDataDelegate = self
    }

    func updateOnReceive() {
        missionsDatabase.updateAll(with: statisticsDatabase)
    }

}
