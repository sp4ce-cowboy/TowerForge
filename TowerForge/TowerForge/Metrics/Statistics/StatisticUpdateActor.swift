//
//  StatisticUpdateActor.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

protocol AnyStatisticUpdateActor {
    func updateStatistic(statistic: Statistic, withEvent event: Any?)
}

// typealias StatisticUpdateActor = ((Statistic, (any TFEvent)?) -> Void)?
/// This struct contains pairs that each Statistic will refer to,
/// to act accordingly when an EventType is executed elsewhere.
class StatisticUpdateActor<T: TFEvent> {
    var action: ((Statistic, T?) -> Void)?

    init(action: ((Statistic, T?) -> Void)? = nil) {
        self.action = action
    }
}

struct AnyStatisticUpdateActorWrapper<T: TFEvent>: AnyStatisticUpdateActor {
    private let _updateStatistic: ((Statistic, T?) -> Void)?

    init<U: StatisticUpdateActor<T>>(_ actor: U) {
        self._updateStatistic = actor.action
    }

    init(updateStatistic: ((Statistic, T?) -> Void)?) {
        self._updateStatistic = updateStatistic
    }

    func updateStatistic(statistic: Statistic, withEvent event: Any?) {
        if let event = event as? T {
            _updateStatistic?(statistic, event)
        } else {
            // Handle the case where event cannot be cast to T, possibly call with nil
            Logger.log("Warning: Attempted to pass an event of the wrong type to a StatisticUpdateActor")
            _updateStatistic?(statistic, nil)
        }
    }
}
