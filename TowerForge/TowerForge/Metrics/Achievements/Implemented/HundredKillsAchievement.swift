//
//  HundredKillsAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

final class HundredKillsAchievement: Achievement {

    var achievementName: String = "100 Kills"
    var achievementDescription: String = "Attain 100 total kills in TowerForge"

    var dependentStatistics: [StatisticTypeWrapper: any Statistic] = [:]

    var requiredValues: [StatisticTypeWrapper: Double] {
        [
            TotalKillsStatistic.asType: 100.0
        ]
    }

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.dependentStatistics = stats
    }

}
