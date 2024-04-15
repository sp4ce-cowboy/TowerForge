//
//  CenturionAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

final class CenturionAchievement: Achievement {

    var achievementName: String = "Centurion"
    var achievementDescription: String = "Kill 100 enemies and die 100 times!"

    static var dependentStatisticsTypes: [StatisticTypeWrapper] {
        [
            TotalKillsStatistic.asType,
            TotalDeathsStatistic.asType
        ]
    }

    var dependentStatistics: [StatisticTypeWrapper: any Statistic] = [:]

    var requiredValues: [StatisticTypeWrapper: Double] {
        [
            TotalKillsStatistic.asType: 100.0,
            TotalDeathsStatistic.asType: 100.0
        ]
    }

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.dependentStatistics = stats
    }

}
