//
//  StatisticsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class StatisticsEngine {
    /// Core storage of Statistics
    var statisticsDatabase = StatisticsDatabase()
    var eventStatisticLinks = EventStatisticLinkDatabase()
    var inferenceEngines: [InferenceEngine] = []

    init() {
        self.initializeStatistics()
        self.setUpLinks()
    }

    /// Add statistics links
    func setUpLinks() {
        eventStatisticLinks.addStatisticLink(for: KillEvent.self,
                                             with: statisticsDatabase.getStatistic(for: TotalKillsStatistic.asType))

        eventStatisticLinks.addStatisticLink(for: GameStartEvent.self,
                                             with: statisticsDatabase.getStatistic(for: TotalGamesStatistic.asType))

        eventStatisticLinks.addStatisticLink(for: DeathEvent.self,
                                             with: statisticsDatabase.getStatistic(for: TotalDeathsStatistic.asType))
    }

    private func initializeStatistics() {
        eventStatisticLinks = StatisticsFactory.getDefaultEventLinkDatabase()
        statisticsDatabase = StatisticsFactory.getDefaultStatisticsDatabase()
        loadStatistics()
    }

    /// Main update function
    func updateStatisticsOnReceive<T: TFEvent>(_ event: T) {
        let eventType = TFEventTypeWrapper(type: T.self)
        guard let stats = eventStatisticLinks.getStatisticLinks(for: eventType) else {
            return
        }

        stats.forEach { $0.update(for: eventType) }
        saveStatistics()
    }

    private func saveStatistics() {
        statisticsDatabase.saveToFirebase()
    }

    private func loadStatistics() {
        statisticsDatabase.loadFromFirebase()
    }

}
