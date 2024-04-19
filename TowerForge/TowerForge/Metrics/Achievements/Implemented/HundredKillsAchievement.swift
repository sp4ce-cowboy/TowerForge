//
//  HundredKillsAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

final class HundredKillsAchievement: Achievement {
    var name: String = "100 Kills"
    var description: String = "Attain 100 total kills in TowerForge"
    var currentParameters: [StatisticTypeWrapper: any Statistic] = [:]

    static var definedParameters: [StatisticTypeWrapper: Double] =
    [
        TotalKillsStatistic.asType: 200.0
    ]

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.currentParameters = stats
    }

}
