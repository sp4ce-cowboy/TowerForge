//
//  StatisticsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

class StatisticsEngine: InferenceDataDelegate {
    /// Core storage of Statistics
    weak var statsEngineDelegate: StatisticsEngineDelegate?
    var statisticsDatabase: StatisticsDatabase
    var eventStatisticLinks = EventStatisticLinkDatabase()
    var inferenceEngines: [InferenceEngineTypeWrapper: InferenceEngine] = [:]

    /*init() {
        self.initializeStatistics()
        self.loadStatistics()
        self.setUpLinks()
        self.setUpInferenceEngines()
    }*/

    /*init(with statistics: StatisticsDatabase) {
        self.statisticsDatabase = statistics
        self.initializeStatistics()
        self.setUpLinks()
        self.setUpInferenceEngines()
    }*/

    init(with storageHandler: StatisticsEngineDelegate) {
        self.statsEngineDelegate = storageHandler
        self.statisticsDatabase = storageHandler.statisticsDatabase
        self.initializeStatistics()
        self.setUpLinks()
        self.setUpInferenceEngines()
    }

    deinit {
        Logger.log("DEINIT: StatisticsEngine is deinitialized", self)
    }

    /// Add statistics links manually
    private func setUpLinks() {
        let links = StatisticsFactory.eventStatisticLinks
        for key in links.keys {
            links[key]?.forEach {
                eventStatisticLinks.addStatisticLink(for: key.type,
                                                     with: statisticsDatabase.getStatistic(for: $0))
            }
        }
    }

    private func initializeStatistics() {
        eventStatisticLinks = StatisticsFactory.getDefaultEventLinkDatabase()
    }

    private func setUpInferenceEngines() {
        InferenceEngineFactory.availableInferenceEngines.forEach { self.addInferenceEngine($0(self)) }
    }

    func addInferenceEngine(_ engine: InferenceEngine) {
        inferenceEngines[engine.asType] = engine
    }

    /// Main update function
   func update<T: TFEvent>(with event: T) {
       self.updateStatisticsOnReceive(event)
       self.notifyInferenceEngines()
    }

    /// Transfers over all transient metrics within statistics to permanent value.
    func finalizeAndSave() {
        Logger.log("------------------- STATISTICS ARE FINALIZED ----------------------- ", self)
        statisticsDatabase.statistics.values.forEach { $0.finalizeStatistic() }
        saveStatistics()
    }

    /// Main update function
   private func updateStatisticsOnReceive<T: TFEvent>(_ event: T) {
        let eventType = TFEventTypeWrapper(type: T.self)
        guard let stats = eventStatisticLinks.getStatisticLinks(for: eventType) else {
            return
        }

        // stats.forEach { $0.update(for: eventType) }
        stats.forEach { $0.update(for: event) }
        //saveStatistics()
    }

    /// TODO: Consider if passing the stats database directly is better or
    /// to follow delegate pattern and have unowned statsEngine/db variables inside
    /// InferenceEngines
    func notifyInferenceEngines() {
        inferenceEngines.values.forEach { $0.updateOnReceive() }
    }

    func getCurrentRank() -> Rank? {
        if let rankEngine = inferenceEngines[RankingEngine.asType] as? RankingEngine {
            return rankEngine.currentRank
        }
        return nil
    }

    func getCurrentExp() -> Double? {
        if let rankEngine = inferenceEngines[RankingEngine.asType] as? RankingEngine {
            return rankEngine.currentExp
        }
        return nil
    }

    private func saveStatistics() {
        Logger.log("STATISTICS_ENGINE SAVE: Statistics save triggered", self)
        Logger.log("STATISTICS_ENGINE SAVE: \(String(describing: statsEngineDelegate?.statisticsDatabase.toString()))", self)
        statsEngineDelegate?.save()
        // _ = StorageManager.saveUniversally(statistics)
    }

    /*private func loadStatistics() {
        if let loadedStats = StorageManager.loadUniversally() {
            statisticsDatabase = loadedStats
        }
    }*/

}
