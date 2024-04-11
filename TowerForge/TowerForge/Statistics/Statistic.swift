//
//  Statistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

struct StatisticTypeWrapper {
    let type: Statistic.Type
}

extension StatisticTypeWrapper: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }
}

extension StatisticTypeWrapper: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

/// Each Statistic can be identified with a name and it will be linked to a particular
/// event.
protocol Statistic {
    var statisticName: StatisticName { get }
    var statisticUpdateLinks: StatisticUpdateLinkDatabase { get set }

    /// The original value of the statistic prior to the start of the game
    var statisticOriginalValue: Double { get set }
    var statisticAdditionalValue: Double { get set }
    var statisticCurrentValue: Double { get }

    func updateOriginalValue(by amount: Double)
    func updateAdditionalValue(by amount: Double)
    func update(for eventType: TFEventTypeWrapper)

}

extension Statistic {

    var statisticCurrentValue: Double {
        statisticOriginalValue + statisticOriginalValue
    }

    mutating func updateOriginalValue(by amount: Double) {
        statisticOriginalValue += amount
    }

    mutating func updateAdditionalValue(by amount: Double) {
        statisticAdditionalValue += amount
    }

    mutating func recalibrateStatistic() {
        statisticOriginalValue += statisticAdditionalValue
        statisticAdditionalValue = .zero
    }
    
    mutating func update(for eventType: TFEventTypeWrapper) {
        guard let
    }

}
