//
//  StatisticUpdateLinkDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

/// This struct contains pairs that each Statistic will refer to,
/// to act accordingly when an EventType is executed elsewhere.
typealias StatisticUpdateActor = ((Statistic) -> Void)?

class StatisticUpdateLinkDatabase {
    var statisticUpdateLinks: [TFEventTypeWrapper: StatisticUpdateActor]

    init(statisticUpdateLinks: [TFEventTypeWrapper: StatisticUpdateActor] = [:]) {
        self.statisticUpdateLinks = statisticUpdateLinks
    }

    func getAllEventTypes() -> [TFEventTypeWrapper] {
        Array(statisticUpdateLinks.keys)
    }

    func registerEmptyEventType<T: TFEvent>(for eventType: T.Type) {
        let wrappedEvent = TFEventTypeWrapper(type: eventType)
        statisticUpdateLinks[wrappedEvent] = nil
    }

    func removeEventType<T: TFEvent>(for eventType: T.Type) {
        let wrappedEvent = TFEventTypeWrapper(type: eventType)
        statisticUpdateLinks.removeValue(forKey: wrappedEvent)
    }

    func addStatisticUpdateActor<T: TFEvent>(for eventType: T.Type,
                                             with statisticUpdateActor: StatisticUpdateActor) {
        let wrappedEvent = TFEventTypeWrapper(type: eventType)
        statisticUpdateLinks[wrappedEvent] = statisticUpdateActor
    }

    func getStatisticUpdateActor(for eventType: TFEventTypeWrapper) -> StatisticUpdateActor? {
        statisticUpdateLinks[eventType]
    }

}
