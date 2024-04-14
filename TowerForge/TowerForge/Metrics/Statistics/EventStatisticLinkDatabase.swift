//
//  EventLinkDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class EventStatisticLinkDatabase {
    var eventLinks: [TFEventTypeWrapper: [Statistic]] = [:]

    init(eventLinks: [TFEventTypeWrapper: [Statistic]] = [:]) {
        self.eventLinks = eventLinks
    }

    func getAllEventTypes() -> [TFEventTypeWrapper] {
        Array(eventLinks.keys)
    }

    func registerEmptyEventType<T: TFEvent>(for eventType: T.Type) {
        let wrappedEvent = TFEventTypeWrapper(type: eventType)
        eventLinks[wrappedEvent] = []
    }

    func removeEventType<T: TFEvent>(for eventType: T.Type) {
        let wrappedEvent = TFEventTypeWrapper(type: eventType)
        eventLinks.removeValue(forKey: wrappedEvent)
    }

    func addStatisticLink<T: TFEvent>(for eventType: T.Type,
                                      with statistic: Statistic?) {
        let wrappedValue = TFEventTypeWrapper(type: eventType)
        if let stat = statistic {
            eventLinks[wrappedValue]?.append(stat)
        }
    }

    func getStatisticLinks(for eventType: TFEventTypeWrapper) -> [Statistic]? {
        eventLinks[eventType]
    }

}
