//
//  MassEffectMission.swift
//  TowerForge
//
//  Created by Rubesh on 20/4/24.
//

import Foundation

final class MassEffectMission: Mission {
    var name: String = "Mass Effect"
    var description: String = "Attain 100 Kills & Deaths in 1 game"
    var currentParameters: [StatisticTypeWrapper: any Statistic]

    static var definedParameters: [StatisticTypeWrapper: Double] {
        [
            TotalKillsStatistic.asType: 100.0,
            TotalDeathsStatistic.asType: 100.0
        ]
    }

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.currentParameters = stats
    }
}
