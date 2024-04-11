//
//  StatisticsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

protocol StatisticsUpdateDelegate: AnyObject {
    func updateOnReceive(_ eventType: TFEventTypeWrapper)
}

class StatisticsEngine {
    var eventStatisticLinks = EventStatisticLinkDatabase()

    init(eventStatisticLinks: EventStatisticLinkDatabase = EventStatisticLinkDatabase()) {
        self.eventStatisticLinks = eventStatisticLinks
    }

    /// Main update
    func updateStatisticsOnReceive(_ eventType: TFEventTypeWrapper) {
        guard let stats = eventStatisticLinks.getStatisticLinks(for: eventType) else {
            return
        }

        stats.forEach { $0.update(for: eventType) }
    }

    /// Add statistics links
    func setUp() {
        self.initializeStatisticsDatabase()
        eventStatisticLinks.addStatisticLink(for: KillEvent.self, with: KillStatistic())
    }

    private func initializeStatisticsDatabase() {
        eventStatisticLinks = StatisticsFactory.getDefaultEventLinkDatabase()
    }

}
