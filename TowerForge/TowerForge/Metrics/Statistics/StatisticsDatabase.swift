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
    }

    func addStatistic(for statName: StatisticTypeWrapper) {
        statistics[statName] = statName.type.init()
    }

    func getStatistic(for statName: StatisticTypeWrapper) -> Statistic? {
        statistics[statName]
    }

    func setToDefault() {
        statistics = StatisticsFactory.getDefaultStatisticsDatabase().statistics
    }
}
