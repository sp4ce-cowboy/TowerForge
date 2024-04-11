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
protocol Statistic: AnyObject, Codable {
    var statisticName: StatisticName { get }
    var statisticUpdateLinks: StatisticUpdateLinkDatabase { get }

    /// The original value of the statistic prior to the start of the game
    var statisticValue: Double { get set }
    // var statisticAdditionalValue: Double { get set }
    // var statisticCurrentValue: Double { get }

    func update(for eventType: TFEventTypeWrapper)
    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase
    func getEventLinksOnly() -> [TFEventTypeWrapper]

    init(name: StatisticName, value: Double)

}

extension Statistic {

    func updateValue(by value: Double) {
        statisticValue += value
    }

    func update(for eventType: TFEventTypeWrapper) {
        guard let updateLink = statisticUpdateLinks
                            .getStatisticUpdateActor(for: eventType) else {
            return
        }

        updateLink?(self)
        Logger.log("Value update for eventType \(eventType)", self)
    }

    func getEventLinksOnly() -> [TFEventTypeWrapper] {
        statisticUpdateLinks.getAllEventTypes()
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: StorageEnums.StatisticDefaultCodingKeys.self)
        try container.encode(statisticName, forKey: .statisticName)
        try container.encode(statisticValue, forKey: .statisticValue)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: StorageEnums.StatisticDefaultCodingKeys.self)
        let name = try container.decode(StatisticName.self, forKey: .statisticName)
        let value = try container.decode(Double.self, forKey: .statisticValue)

        self.init(name: name, value: value)
    }

}
