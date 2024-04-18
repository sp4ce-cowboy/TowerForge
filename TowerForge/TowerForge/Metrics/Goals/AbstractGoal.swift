//
//  Goal.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

/// The TFAchievement protocol specifies the requirements for all concrete
/// achievements to conform to.
///
/// Each achievement will correspond to a collection of statistics.
protocol AbstractGoal: AnyObject {
    static var goalType: AbstractGoalTypeWrapper { get }
    var name: String { get }
    var description: String { get }
    var imageIdentifier: String { get }

    static var definedParameters: [StatisticTypeWrapper: Double] { get }
    var currentParameters: [StatisticTypeWrapper: Statistic] { get set }

    var currentValues: [StatisticTypeWrapper: Double] { get }
    var requiredValues: [StatisticTypeWrapper: Double] { get }

    var currentProgressRates: [StatisticTypeWrapper: Double] { get }
    var overallProgressRate: Double { get }
    var isComplete: Bool { get }

    func loadStatistic(_ stat: Statistic)
    func update(with stats: StatisticsDatabase)

    init(dependentStatistics: [Statistic])

}

extension AbstractGoal {

    var imageIdentifier: String { "coin" }

    static var goalType: AbstractGoalTypeWrapper {
        AbstractGoalTypeWrapper(type: Self.self)
    }

    var requiredValues: [StatisticTypeWrapper: Double] {
        Self.definedParameters
    }

    func loadStatistic(_ stat: any Statistic) {
        currentParameters[stat.statisticName] = stat
    }

    func update(with stats: StatisticsDatabase) {
        currentParameters.keys.forEach {
            self.currentParameters[$0] = stats.statistics[$0]
        }
    }

    var currentProgressRates: [StatisticTypeWrapper: Double] {
        var rates: [StatisticTypeWrapper: Double] = [:]
        requiredValues.keys.forEach { key in
            if let requiredValue = requiredValues[key], let currentValue = currentValues[key] {
                rates[key] = currentValue / requiredValue
            }
        }
        return rates
    }

    var overallProgressRate: Double {
        currentProgressRates.values
            .reduce(into: .zero) { $0 += $1 }
            .divide(by: Double(currentProgressRates.values.count))
    }

    var overallProgressRateRounded: Double {
        overallProgressRate.rounded() > 1.0 ? 1.0 : overallProgressRate.rounded()
    }

    var isComplete: Bool {
        currentProgressRates.values.allSatisfy { !$0.isLess(than: .unit) }
    }

}
