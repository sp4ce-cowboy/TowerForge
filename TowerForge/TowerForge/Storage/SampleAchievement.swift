//
//  SampleAchievement.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

class SampleAchievement: Storable {

    typealias DataType = Int
    var storableId = UUID()
    var storableName: TFStorableType
    var storableValue: Int = 0

    var killCount: Int {
        get { storableValue }
        set { storableValue = newValue }
    }

    required init(id: UUID, name: TFStorableType, value: Int) {
        self.storableId = id
        self.storableName = name
        self.storableValue = value
    }

    private func updateKillCount(_ count: Int) {
        killCount = count
    }

    func incrementKillCount() {
        killCount += 1
    }

    func decrementKillCount() {
        killCount -= 1
    }
}
