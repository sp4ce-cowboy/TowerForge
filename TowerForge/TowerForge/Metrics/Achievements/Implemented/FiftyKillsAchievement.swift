//
//  50KillsAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

final class FiftyKillsAchievement: Achievement {
    var achievementName: String = "50 Kills"
    var achievementDescription: String = "Attain 50 total kills in TowerForge"
    var currentParameters: [StatisticTypeWrapper: any Statistic]

    static var definedParameters: [StatisticTypeWrapper: Double] {
        [
            TotalKillsStatistic.asType: 50.0
        ]
    }

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.currentParameters = stats
    }

}
