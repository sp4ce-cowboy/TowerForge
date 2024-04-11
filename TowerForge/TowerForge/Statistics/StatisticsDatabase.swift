//
//  StatisticsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation
import FirebaseDatabaseInternal

class StatisticsDatabase {
    var statistics: [StatisticName: Statistic] = [:]

    init(statistics: [StatisticName: Statistic] = [:]) {
        self.statistics = statistics
    }

    private var defaultStatisticDecoder: [StatisticName: (JSONDecoder, Data) throws -> Statistic] {
        [
            .totalKills: { decoder, data in try decoder.decode(TotalKillsStatistic.self, from: data) },
            .totalGamesPlayed: { decoder, data in try decoder.decode(TotalGamesStatistic.self, from: data) },
            .totalDeaths: { decoder, data in try decoder.decode(TotalDeathsStatistic.self, from: data) }
        ]
    }

    private var defaultStatisticGenerator: [StatisticName: () -> Statistic] {
        [
            .totalKills: { TotalKillsStatistic() },
            .totalGamesPlayed: { TotalGamesStatistic() },
            .totalDeaths: { TotalDeathsStatistic() }
        ]
    }

    func addStatistic(for statName: StatisticName) {
        statistics[statName] = defaultStatisticGenerator[statName]?()
    }

    func getStatistic(for statName: StatisticName) -> Statistic {
        statistics[statName] ?? DefaultStatistic()
    }

    /// TODO: Maybe can change this to firebase repository?
    func load() {
        let databaseReference = FirebaseDatabaseReference(.Statistics)
        databaseReference.child("statistics").getData(completion: { error, snapshot in
            guard error == nil else {
                Logger.log(error!.localizedDescription)
                return
            }

            if let value = snapshot?.value as? [String: Any] {
                for (key, statisticValue) in value {
                    guard let statisticDict = statisticValue as? [String: Any],
                          let statisticData = try? JSONSerialization
                                                        .data(withJSONObject: statisticDict, options: []) else {
                        continue
                    }

                    do {
                        guard let statisticName = StatisticName(rawValue: key) else {
                            continue
                        }
                        let decoder = JSONDecoder()
                        let statistic: Statistic?
                        statistic = try self.defaultStatisticDecoder[statisticName]?(decoder, statisticData)
                        if let stat = statistic { self.statistics[statisticName] = stat }

                    } catch {
                        Logger.log("Error decoding \(key):, \(error)")
                    }
                }
            }
        })
    }

    func save() {
        let databaseReference = FirebaseDatabaseReference(.Statistics)
        var statisticsDictionary = [String: Any]()

        for (name, statistic) in statistics {
            do {
                let data = try JSONEncoder().encode(statistic)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                statisticsDictionary[name.rawValue] = dictionary
            } catch {
                Logger.log("Error encoding statistic \(name): \(error)")
            }
        }

        databaseReference.child("statistics").setValue(statisticsDictionary) { error, _ in
            if let error = error {
                Logger.log("Data could not be saved: \(error).")
            } else {
                Logger.log("Data saved successfully!")
            }
        }
    }

}
