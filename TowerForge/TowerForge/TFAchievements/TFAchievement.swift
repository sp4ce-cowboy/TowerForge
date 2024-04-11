//
//  TFAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

struct TFAchievementTypeWrapper: Equatable, Hashable {
    let type: TFAchievement.Type

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

/// The TFAchievement protocol specifies the requirements for all concrete
/// achievements to conform to.
protocol TFAchievement {
    var achievementName: String { get }
    var achievementDescription: String { get }

    var isComplete: Bool { get }
    var relatedStatistics: [Statistic] { get }

    func loadStatistic(for stat: Statistic, by value: Int)
    func updateStatistic(for stat: Statistic, by value: Int)

}

extension TFAchievement {

}
