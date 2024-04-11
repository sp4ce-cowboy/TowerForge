//
//  Statistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

struct StatisticTypeWrapper: Equatable, Hashable {
    let type: Statistic.Type

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

/// Each Statistic can be identified with a name and it will be linked to a particular
/// event.
protocol Statistic: AnyObject {
    var statisticName: StatisticName { get }
    var statisticUpdateLinks: StatisticUpdateLinkDatabase { get }

    /// The original value of the statistic prior to the start of the game
    var statisticOriginalValue: Double { get set }
    var statisticAdditionalValue: Double { get set }
    var statisticCurrentValue: Double { get }

    func update(for eventType: TFEventTypeWrapper)
    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase
    func getEventLinksOnly() -> [TFEventTypeWrapper]

}

extension Statistic {

    var statisticCurrentValue: Double {
        statisticOriginalValue + statisticOriginalValue
    }

    func updateOriginalValue(by amount: Double) {
        statisticOriginalValue += amount
    }

    func updateAdditionalValue(by amount: Double) {
        statisticAdditionalValue += amount
    }

    func recalibrateStatistic() {
        statisticOriginalValue += statisticAdditionalValue
        statisticAdditionalValue = .zero
    }

    func update(for eventType: TFEventTypeWrapper) {
        guard let updateLink = statisticUpdateLinks
                            .getStatisticUpdateActor(for: eventType) else {
            return
        }

        updateLink?(self)
    }

    func getEventLinksOnly() -> [TFEventTypeWrapper] {
        statisticUpdateLinks.getAllEventTypes()
    }

}
