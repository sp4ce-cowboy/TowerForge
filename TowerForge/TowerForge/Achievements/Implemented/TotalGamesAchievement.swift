//
//  SampleAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// A sample achievement that keeps track of total games started.
class TotalGamesAchievement: Achievement {
    var storableId = UUID()
    var storableName: TFStorableType = .totalGamesAchievement
    var storableValue: Double = 0

    var gameCount: Int {
        get { Int(storableValue) }
        set { storableValue = Double(newValue) }
    }

    required init(id: UUID = UUID(),
                  name: TFStorableType = .totalGamesAchievement,
                  value: Double = 0) {
        self.storableId = id
        self.storableName = name
        self.storableValue = value
    }

    private func updateGameCount(to count: Int) {
        gameCount = count
    }

    func incrementGameCount() {
        gameCount += 1
    }

    func decrementGameCount() {
        gameCount -= 1
    }
}
