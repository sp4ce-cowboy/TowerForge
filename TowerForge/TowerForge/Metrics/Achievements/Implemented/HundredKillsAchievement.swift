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

    static var definedParameters: [StatisticTypeWrapper: Double] =
    [
        TotalKillsStatistic.asType: 100.0
    ]

    var currentParameters: [StatisticTypeWrapper: any Statistic] = [:]

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.currentParameters = stats
    }

}
