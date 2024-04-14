//
//  StatisticsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation
import FirebaseDatabaseInternal

final class StatisticsDatabase {
    var statistics: [StatisticTypeWrapper: Statistic] = [:]

    init(_ stats: [StatisticTypeWrapper: Statistic] = [:]) {
        self.statistics = stats
        // self.loadFromFirebase()
        // Logger.log("Current killcount is \(String(describing: self.statistics[TotalKillsStatistic.asType]))", self)
    }

    func addStatistic(for statName: StatisticTypeWrapper) {
        statistics[statName] = statName.type.init()
    }

    func getStatistic(for statName: StatisticTypeWrapper) -> Statistic? {
        statistics[statName]
    }
}
