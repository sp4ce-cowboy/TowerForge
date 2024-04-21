//
//  KillStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

final class TotalGamesStatistic: Statistic {
    static let expMultiplier: Double = 100
    var prettyName: String = "Total Games"
    var permanentValue: Double = .zero
    var currentValue: Double = .zero
    var maximumCurrentValue: Double

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

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: GameStartEvent.self)
        let eventUpdateClosure: (Statistic, GameStartEvent?) -> Void = { statistic, event in
            statistic.updateCurrentValue(by: 1.0)
            Logger.log("Updating statistic with event detail: \(String(describing: event))", self)
        }

        let statisticUpdateActor = StatisticUpdateActor<GameStartEvent>(action: eventUpdateClosure)
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
          let max = try container.decode(Double.self, forKey: .maximumCurrentValue)

          self.init(permanentValue: value, currentValue: current, maxCurrentValue: max)
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
