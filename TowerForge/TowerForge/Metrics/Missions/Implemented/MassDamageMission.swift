//
//  ThousandDamageMission.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

final class MassDamageMission: Mission {
    var name: String = "Mass Damage"
    var description: String = "Attain 1000 Damage in 1 game"
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
