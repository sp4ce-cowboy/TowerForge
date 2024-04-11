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

    func getStatistic(for statName: StatisticName) -> Statistic? {
        statistics[statName]
    }

    func load() {
        let databaseReference = FirebaseDatabaseReference(.Statistics)

        databaseReference.child("statistics").getData(completion: { error, snapshot in
            guard error == nil else {
                Logger.log(error!.localizedDescription)
                return
            }

            if let value = snapshot?.value as? [String: Any] {
                for (key, statisticValue) in value {
                    guard let statisticData = try? JSONSerialization.data(withJSONObject:
                                                                            statisticValue, options: []) else {

                        Logger.log("Can't create data from statisticValue")
                        continue
                    }
                    do {
                        let statistic = try JSONDecoder().decode(Statistic.self, from: statisticData)
                        self.statistics[StatisticName(rawValue: key)!] = statistic
                    } catch {
                        Logger.log("Error decoding statistic for \(key): \(error)")
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
