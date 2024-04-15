//
//  StatisticUpdateLinkDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

// typealias StatisticUpdateActor = ((Statistic, (any TFEvent)?) -> Void)?
/// This struct contains pairs that each Statistic will refer to,
/// to act accordingly when an EventType is executed elsewhere.
class StatisticUpdateActor<T: TFEvent> {
    var action: ((Statistic, T?) -> Void)?

    init(action: ((Statistic, T?) -> Void)? = nil) {
        self.action = action
    }
}

protocol AnyStatisticUpdateActor {
    func updateStatistic(statistic: Statistic, withEvent event: Any?)
}

struct AnyStatisticUpdateActorWrapper<T: TFEvent>: AnyStatisticUpdateActor {
    private let _updateStatistic: (Statistic, T?) -> Void

    init<U: StatisticUpdateActor<T>>(_ actor: U) {
        self._updateStatistic = actor.action!
    }

    func updateStatistic(statistic: Statistic, withEvent event: Any?) {
        if let event = event as? T {
            _updateStatistic(statistic, event)
        } else {
            // Handle the case where event cannot be cast to T, possibly call with nil
            Logger.log("Warning: Attempted to pass an event of the wrong type to a StatisticUpdateActor")
            _updateStatistic(statistic, nil)
        }
    }
}

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
