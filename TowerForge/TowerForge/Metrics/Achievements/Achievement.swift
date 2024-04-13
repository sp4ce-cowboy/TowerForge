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
protocol Achievement {
    var achievementName: String { get }
    var achievementDescription: String { get }

    var isComplete: Bool { get }

    var requiredValues: [StatisticTypeWrapper: Double] { get }
    var currentValues: [StatisticTypeWrapper: Double] { get }

    var currentProgressRates: [StatisticTypeWrapper: Double] { get }
    var dependentStatistics: [StatisticTypeWrapper: Statistic] { get }

    func update()

}

extension Achievement {

}
