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
    /// Core storage of Statistics
    var statisticsDatabase = StatisticsDatabase()
    var eventStatisticLinks = EventStatisticLinkDatabase()

    init(eventStatisticLinks: EventStatisticLinkDatabase = EventStatisticLinkDatabase()) {
        self.eventStatisticLinks = eventStatisticLinks
        self.setUp()
    }

    /// Main update function
    func updateStatisticsOnReceive<T: TFEvent>(_ event: T) {
        let eventType = TFEventTypeWrapper(type: T.self)
        guard let stats = eventStatisticLinks.getStatisticLinks(for: eventType) else {
            return
        }

        stats.forEach { $0.update(for: eventType) }
        Logger.log("\(self.statisticsDatabase)")
        saveStatistics()
    }

    /// Add statistics links
    func setUp() {
        self.initializeStatistics()
        eventStatisticLinks.addStatisticLink(for: KillEvent.self,
                                             with: statisticsDatabase.getStatistic(for: .totalKills))

        eventStatisticLinks.addStatisticLink(for: GameStartEvent.self,
                                             with: statisticsDatabase.getStatistic(for: .totalGamesPlayed))

        eventStatisticLinks.addStatisticLink(for: DeathEvent.self,
                                             with: statisticsDatabase.getStatistic(for: .totalDeaths))
    }

    private func initializeStatistics() {
        eventStatisticLinks = StatisticsFactory.getDefaultEventLinkDatabase()
        statisticsDatabase = StatisticsFactory.getDefaultStatisticsDatabase()
        loadStatistics()
    }

    private func saveStatistics() {
        statisticsDatabase.save()
    }

    private func loadStatistics() {
        statisticsDatabase.load()

    }

}
