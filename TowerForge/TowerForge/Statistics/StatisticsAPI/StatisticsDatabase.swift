//
//  StatisticsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 12/4/24.
//

import Foundation
import FirebaseDatabaseInternal

class StatisticsDatabase {
    var statistics: [StatisticTypeWrapper: Statistic] = [:]

    init() {
        self.load()
    }

    func addStatistic(for statName: StatisticTypeWrapper) {
        statistics[statName] = defaultStatisticGenerator[statName]?()
    }

    func getStatistic(for statName: StatisticTypeWrapper) -> Statistic {
        statistics[statName] ?? DefaultStatistic()
    }

    private var defaultStatisticDecoder: [StatisticTypeWrapper: (JSONDecoder, Data) throws -> Statistic] {
        [
            TotalKillsStatistic.asType: { decoder, data in try decoder.decode(TotalKillsStatistic.self, from: data) },
            TotalGamesStatistic.asType: { decoder, data in try decoder.decode(TotalGamesStatistic.self, from: data) },
            TotalDeathsStatistic.asType: { decoder, data in try decoder.decode(TotalDeathsStatistic.self, from: data) }
        ]
    }

    private var defaultStatisticGenerator: [StatisticTypeWrapper: () -> Statistic] {
        [
            TotalKillsStatistic.asType: { TotalKillsStatistic() },
            TotalGamesStatistic.asType: { TotalGamesStatistic() },
            TotalDeathsStatistic.asType: { TotalDeathsStatistic() }
        ]
    }

    /// TODO: Maybe can change this to FirebaseRepository
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
                        guard let statisticType = NSClassFromString(key) as? Statistic.Type else {
                            continue
                        }
                        let statisticName = statisticType.asType
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
        var statisticsDictionary = [StatisticTypeWrapper: Any]()

        for (name, statistic) in statistics {
            do {
                let data = try JSONEncoder().encode(statistic)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                statisticsDictionary[name] = dictionary
            } catch {
                Logger.log("Error encoding statistic \(name): \(error)")
            }
        }

        databaseReference.child("statistics").setValue(statisticsDictionary) { error, _ in
            if let error = error {
                Logger.log("Data could not be saved: \(error).")
            } else {
                Logger.log("StorageDatabase saved successfully!", self)
            }
        }
    }

}
