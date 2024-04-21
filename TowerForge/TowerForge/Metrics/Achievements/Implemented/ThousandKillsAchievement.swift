//
//  HundredKillsAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

final class ThousandKillsAchievement: Achievement {
    var name: String = "1000 Kills"
    var description: String = "Attain 1000 total kills in TowerForge"
    var currentParameters: [StatisticTypeWrapper: any Statistic] = [:]

    static var definedParameters: [StatisticTypeWrapper: Double] =
    [
        TotalKillsStatistic.asType: 1_000.0
    ]

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.currentParameters = stats
    }

}
