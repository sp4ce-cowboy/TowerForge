//
//  Statistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

/// A Statistic is a metric to be tracked within TowerForge.
protocol Statistic: AnyObject, Codable {
    var statisticName: StatisticTypeWrapper { get }

    /// The original value of the statistic prior to the start of the game seequence
    var permanentValue: Double { get set }

    /// The changes incurred to the statistic in the course of the current game sequence
    var currentValue: Double { get set }

    /// A computed sum of the permanent value and the current value of the statistic
    var currentTotalValue: Double { get }

    /// The principal interface for modifying the Statistic
    func update(for eventType: TFEventTypeWrapper)

    /// Returns a StatisticUpdateLinkDatabase pertaining to this Statistic.
    /// Conforming Statistic types will have to implement their own links between event
    /// types and the action to take upon reception of that event's execution.
    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase
    func getEventLinksOnly() -> [TFEventTypeWrapper]

    init(permanentValue: Double, currentValue: Double)

}

extension Statistic {

    init() {
        self.init(permanentValue: .zero, currentValue: .zero)
    }

    static func equals(lhs: Self, rhs: Self) -> Bool {
        (lhs.statisticName == rhs.statisticName) &&
        (lhs.permanentValue == rhs.permanentValue)
    }

    /// Compares two Statistic objects of the same type and returns that whose permanent value is
    /// larger
    static func maximum(lhs: Self, rhs: Self) -> Self {
        Double.maximumMagnitude(lhs.permanentValue, rhs.permanentValue) == lhs.permanentValue ? lhs : rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(statisticName)
        hasher.combine(permanentValue)
    }
}

/// This extension adds default utility functions such as generic increments
/// and decrements of values.
extension Statistic {

    static var asType: StatisticTypeWrapper {
        StatisticTypeWrapper(type: Self.self)
    }

    var statisticName: StatisticTypeWrapper {
        StatisticTypeWrapper(type: Self.self)
    }

    /// Returns the total value of the statistic taking into account the
    /// permanent value of the Statistic prior to changes and the current changes
    /// to value.
    var currentTotalValue: Double {
        permanentValue + currentValue
    }

    /// Increments the permanent value of the statistic by the given amount
    func updatePermanentValue(by value: Double) {
        permanentValue += value
    }

    /// Increments the current value of the statistic by the given amount
    func updateCurrentValue(by value: Double) {
        currentValue += value
    }

    /// Generic increment of the permanent value
    func permanentValueUnitIncrement() {
        updatePermanentValue(by: 1.0)
    }

    /// Generic increment of the current value
    func currentValueUnitIncrement() {
        updateCurrentValue(by: 1.0)
    }

    /// Finalizes the statistic by adding the current value to the
    /// permanent value and resetting the current value to zero. This is
    /// intended to be executed after the end of a game sequence.
    func finalizeStatistic() {
        updatePermanentValue(by: currentValue)
        currentValue = .zero
    }

    /// Returns the event types for which this Statistic would be involved
    func getEventLinksOnly() -> [TFEventTypeWrapper] {
        self.getStatisticUpdateLinks().getAllEventTypes()
    }

    /// Updates the statistic according to an UpdateActor that is retrieved from the 
    func update(for eventType: TFEventTypeWrapper) {
        guard let updateLink = self.getStatisticUpdateLinks().getStatisticUpdateActor(for: eventType) else {
            return
        }

        updateLink?(self)
        Logger.log("Value update for eventType \(eventType)", self)
    }
}

/// This extension adds default implementations for encoding and decoding a statistic
extension Statistic {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: StatisticCodingKeys.self)
        try container.encode(statisticName, forKey: .statisticName)
        try container.encode(permanentValue, forKey: .permanentValue)
        try container.encode(currentValue, forKey: .currentValue)
    }

    /* TODO: Fix new implementation
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StorageEnums.DynamicCodingKeys.self)
        guard let statKey = DynamicCodingKeys(stringValue: statisticName.asString) else {
            Logger.log("Encoding statistic failed", self)
            return
        }
        var nestedContainer = container.nestedContainer(keyedBy: StatisticCodingKeys.self, forKey: statKey)
        try nestedContainer.encode(permanentValue, forKey: .permanentValue)
        try nestedContainer.encode(currentValue, forKey: .currentValue)
    }*/
}