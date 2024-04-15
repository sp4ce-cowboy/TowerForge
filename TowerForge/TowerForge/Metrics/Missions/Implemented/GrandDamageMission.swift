//
//  ThousandDamageMission.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

final class GrandDamageMission: Mission {
    static var isDone = false

    var missionName: String = "50 Kills"
    var missionDescription: String = "Attain 50 total kills in TowerForge"
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
