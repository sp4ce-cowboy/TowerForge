//
//  MassDeathMission.swift
//  TowerForge
//
//  Created by Rubesh on 20/4/24.
//

import Foundation

final class MassDeathMission: Mission {
    var name: String = "Mass Death"
    var description: String = "Die 100 times in 1 game"
    var currentParameters: [StatisticTypeWrapper: any Statistic]

    static var definedParameters: [StatisticTypeWrapper: Double] {
        [
            TotalDeathsStatistic.asType: 100.0
        ]
    }

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.currentParameters = stats
    }
}
