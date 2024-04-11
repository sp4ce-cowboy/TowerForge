//
//  StatisticUpdateLinkFactory.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

/// This class generates update links i.e. for each statistic,
/// it outputs a dictionary where the keys are event types and the values
/// are closures which should be acted upon if that particular even type were to be executed.
class StatisticUpdateLinkFactory {

    /// Get statistic links for the KillStatistic.
    /// This would require KillEvent.
    static func getKillStatisticLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: KillEvent.self)
        let updateActor: StatisticUpdateActor = { statistic in statistic.updateAdditionalValue(by: 1.0) }
        let eventUpdateDictionary = [eventType: updateActor]
        let statsLink = StatisticUpdateLinkDatabase(statisticUpdateLinks: eventUpdateDictionary)

        return statsLink
    }
}
