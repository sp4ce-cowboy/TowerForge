//
//  StatisticsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class StatisticsEngine {
    /// Core storage of Statistics
    var statistics = StatisticsDatabase()
    var eventStatisticLinks = EventStatisticLinkDatabase()
    var inferenceEngines: [InferenceEngine] = []

    init() {
        self.initializeStatistics()
        self.setUpLinks()
    }

    /// Add statistics links manually
    /// TODO: Consider a more elegant way to do this
    func setUpLinks() {
        eventStatisticLinks.addStatisticLink(for: KillEvent.self,
                                             with: statistics.getStatistic(for: TotalKillsStatistic.asType))

        eventStatisticLinks.addStatisticLink(for: GameStartEvent.self,
                                             with: statistics.getStatistic(for: TotalGamesStatistic.asType))

        eventStatisticLinks.addStatisticLink(for: DeathEvent.self,
                                             with: statistics.getStatistic(for: TotalDeathsStatistic.asType))
    }

    private func initializeStatistics() {
        eventStatisticLinks = StatisticsFactory.getDefaultEventLinkDatabase()
        loadStatistics()
    }

    /// Main update function
   func update<T: TFEvent>(with event: T) {
       self.updateStatisticsOnReceive(event)
       self.notifyInferenceEngines()
    }

    /// Transfers over all transient metrics within statistics to permanent value.
    func finalize() {
        statistics.statistics.values.forEach { $0.finalizeStatistic() }
        saveStatistics()
    }

    /// Main update function
   private func updateStatisticsOnReceive<T: TFEvent>(_ event: T) {
        let eventType = TFEventTypeWrapper(type: T.self)
        guard let stats = eventStatisticLinks.getStatisticLinks(for: eventType) else {
            return
        }

        stats.forEach { $0.update(for: eventType) }
        saveStatistics()
    }

    func addInferenceEngine(_ engine: InferenceEngine) {
        inferenceEngines.append(engine)
    }

    /// TODO: Consider if passing the stats database directly is better or
    /// to follow delegate pattern and have unowned statsEngine/db variables inside
    /// InferenceEngines
    func notifyInferenceEngines() {
        inferenceEngines.forEach { $0.updateOnReceive(stats: statistics) }
    }

    private func saveStatistics() {
        _ = StorageManager.saveUniversally(statistics)
    }

    private func loadStatistics() {
        statistics = StorageManager.loadUniversally()
    }

}
