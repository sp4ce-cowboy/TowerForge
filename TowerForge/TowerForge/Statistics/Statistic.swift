//
//  Statistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

/// Each Statistic can be identified with a name and it will be linked to a particular
/// event.
protocol Statistic {
    var statisticName: StatisticName { get }

    /// The original value of the statistic prior to the start of the game
    var statisticOriginalValue: Double { get set }
    var statisticAdditionalValue: Double { get set }
    var statisticCurrentValue: Double { get }

    /// An Array of events to which this Statistic would be "linked"
    var eventLinks: [TFEvent] { get set }
    func addEventLink<T: TFEvent>(_ event: T)

    func updateOriginalValue(by amount: Double)
    func updateAdditionalValue(by amount: Double)

}

extension Statistic {

    mutating func addEventLink<T: TFEvent>(_ event: T) {
        self.eventLinks.append(event)
    }

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

}
