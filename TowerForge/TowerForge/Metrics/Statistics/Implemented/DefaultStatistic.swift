//
//  DefaultStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

final class DefaultStatistic: Statistic {
    var permanentValue: Double = .zero
    var currentValue: Double = .zero

    init(permanentValue: Double = .zero,
         currentValue: Double = .zero) {
        self.permanentValue = permanentValue
        self.currentValue = currentValue
    }

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: DisabledEvent.self)
        let updateActor: StatisticUpdateActor = { statistic in statistic.updateCurrentValue(by: 1.0) }
        let eventUpdateDictionary = [eventType: updateActor]
        let statsLink = StatisticUpdateLinkDatabase(statisticUpdateLinks: eventUpdateDictionary)

        return statsLink
    }

}
