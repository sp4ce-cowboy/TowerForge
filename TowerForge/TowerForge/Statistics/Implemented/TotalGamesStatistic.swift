//
//  TotalGamesStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation

class TotalGamesStatistic: Statistic {

    var statisticName: StatisticName = .totalGamesPlayed
    var statisticOriginalValue: Double = .zero
    var statisticAdditionalValue: Double = .zero

    var statisticUpdateLinks: StatisticUpdateLinkDatabase {
        self.getStatisticUpdateLinks()
    }

    init() { }

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: GameStartEvent.self)
        let updateActor: StatisticUpdateActor = { statistic in statistic.updateAdditionalValue(by: 1.0) }
        let eventUpdateDictionary = [eventType: updateActor]
        let statsLink = StatisticUpdateLinkDatabase(statisticUpdateLinks: eventUpdateDictionary)

        return statsLink
    }

}
