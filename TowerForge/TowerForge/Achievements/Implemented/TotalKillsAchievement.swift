//
//  TotalKillsAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// A sample achievement that keeps track of kill counts across game instances.
/// The Achievement encapsulates both the name of the Achievement and the value
/// corresponding to that achievement. This can be further isolated into a Trackable
/// type that purely only tracks game statistic if needed later on.
class TotalKillsAchievement: Achievement {
    var storableId = UUID()
    var storableName: TFStorableType = .totalKillsAchievement
    var storableValue: Double = 0

    var killCount: Int {
        get { Int(storableValue) }
        set { storableValue = Double(newValue) }
    }

    required init(id: UUID = UUID(),
                  name: TFStorableType = .totalKillsAchievement,
                  value: Double = 0) {
        self.storableId = id
        self.storableName = name
        self.storableValue = value
    }

    private func updateKillCount(to count: Int) {
        killCount = count
    }

    func incrementKillCount() {
        killCount += 1
    }

    func decrementKillCount() {
        killCount -= 1
    }
}
