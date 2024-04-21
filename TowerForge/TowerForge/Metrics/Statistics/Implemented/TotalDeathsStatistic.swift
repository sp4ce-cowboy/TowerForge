//
//  KillStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

final class TotalDeathsStatistic: Statistic {
    var prettyName: String = "Total Deaths"
    var permanentValue: Double = .zero
    var currentValue: Double = .zero
    var maximumCurrentValue: Double = .zero

    var statisticUpdateLinks: StatisticUpdateLinkDatabase {
        self.getStatisticUpdateLinks()
    }

    init(permanentValue: Double = .zero,
         currentValue: Double = .zero,
         maxCurrentValue: Double = .zero) {
        self.permanentValue = permanentValue
        self.currentValue = currentValue
        self.maximumCurrentValue = maxCurrentValue
    }

    /// The total deaths statistic no longer requires the DeathEvent, it is able
    /// to directly parse a KillEvent to determine whe
    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: KillEvent.self)
        let eventUpdateClosure: (Statistic, KillEvent?) -> Void = { statistic, event in
            guard let event = event, event.player == .ownPlayer else {
                return
            }
            statistic.updateCurrentValue(by: 1.0)
            Logger.log("Updating statistic with event detail: \(String(describing: event))", self)
        }

        let statisticUpdateActor = StatisticUpdateActor<KillEvent>(action: eventUpdateClosure)
        let anyStatisticUpdateActorWrapper = AnyStatisticUpdateActorWrapper(statisticUpdateActor)

        var statisticUpdateLinksMap: [TFEventTypeWrapper: AnyStatisticUpdateActor] = [:]
        statisticUpdateLinksMap[eventType] = anyStatisticUpdateActorWrapper
        return StatisticUpdateLinkDatabase(statisticUpdateLinks: statisticUpdateLinksMap)

    }

    convenience init(from decoder: any Decoder) throws {
          let container = try decoder.container(keyedBy: StatisticCodingKeys.self)
          _ = try container.decode(StatisticTypeWrapper.self, forKey: .statisticName)
          let value = try container.decode(Double.self, forKey: .permanentValue)
          let current = try container.decode(Double.self, forKey: .currentValue)

          self.init(permanentValue: value, currentValue: current)
    }

    func merge<T: Statistic>(with that: T) -> T? {
        guard let that = that as? Self else {
            return nil
        }

        let largerPermanent = max(self.permanentValue, that.permanentValue)
        let largerMaxCurrent = max(self.maximumCurrentValue, that.maximumCurrentValue)

        guard let stat = Self(permanentValue: largerPermanent,
                              currentValue: .zero,
                              maxCurrentValue: largerMaxCurrent) as? T else {
            Logger.log("Statistic merging failed", self)
            return nil
        }

        return stat
    }

}
