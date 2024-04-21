//
//  StatisticsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation
import FirebaseDatabaseInternal

final class StatisticsDatabase: StorageDatabase {
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

    func getPermanentValueFor<T: Statistic>(_ stat: T.Type) -> Double {
        self.getStatistic(for: stat.asType)?.permanentValue ?? .zero
    }

    func setToDefault() {
        statistics = StatisticsFactory.getDefaultStatisticsDatabase().statistics
    }

    func toString() -> String {
        var output = ""
        statistics.values.forEach { output += ($0.toString() + "\n") }
        return output
    }
}
