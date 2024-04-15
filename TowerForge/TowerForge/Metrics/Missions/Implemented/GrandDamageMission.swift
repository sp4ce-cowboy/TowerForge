//
//  ThousandDamageMission.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

final class GrandDamageMission: Mission {
    var missionName: String = "Mission: 1000 Damage"
    var missionDescription: String = "Attain 1000 Damage in 1 game"
    var currentParameters: [StatisticTypeWrapper: any Statistic]

    static var definedParameters: [StatisticTypeWrapper: Double] {
        [
            TotalDamageDealtStatistic.asType: 1_000.0
        ]
    }

    init(dependentStatistics: [Statistic]) {
        var stats: [StatisticTypeWrapper: any Statistic] = [:]
        dependentStatistics.forEach { stats[$0.statisticName] = $0 }
        self.currentParameters = stats
    }
}
