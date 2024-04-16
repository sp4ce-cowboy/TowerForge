//
//  StatisticUpdateLinkDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class StatisticUpdateLinkDatabase {
    var statisticUpdateLinks: [TFEventTypeWrapper: AnyStatisticUpdateActor]

    init(statisticUpdateLinks: [TFEventTypeWrapper: AnyStatisticUpdateActor] = [:]) {
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
                                             with statisticUpdateActor: AnyStatisticUpdateActor) {
        let wrappedEvent = TFEventTypeWrapper(type: eventType)
        statisticUpdateLinks[wrappedEvent] = statisticUpdateActor
    }

    func getStatisticUpdateActor(for eventType: TFEventTypeWrapper) -> AnyStatisticUpdateActor? {
        statisticUpdateLinks[eventType]
    }

}
