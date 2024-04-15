//
//  TFAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

/// The TFAchievement protocol specifies the requirements for all concrete
/// achievements to conform to.
///
/// Each achievement will correspond to a collection of statistics.
protocol Achievement: AnyObject {
    var achievementName: String { get }
    var achievementDescription: String { get }

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

extension Achievement {

    static var asType: AchievementTypeWrapper {
        AchievementTypeWrapper(type: Self.self)
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

    var currentValues: [StatisticTypeWrapper: Double] {
        var values: [StatisticTypeWrapper: Double] = [:]
        currentParameters.keys.forEach { key in
            if let currentStatistic = currentParameters[key] {
                values[key] = currentStatistic.permanentValue
            }
        }

        return values
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
        currentProgressRates.values.reduce(into: .zero) { $0 += $1 }
            .divide(by: Double(currentProgressRates.values.count))
    }

    var overallProgressRateRounded: Double {
        overallProgressRate.rounded()
    }

    var isComplete: Bool {
        currentProgressRates.values.allSatisfy { !$0.isLess(than: .unit) }
    }

}
