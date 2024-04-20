//
//  MissionsDatabase.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

class MissionsDatabase {
    weak var missionsDataDelegate: InferenceDataDelegate?
    var missions: [MissionTypeWrapper: Mission] = [:]

    var count: Int {
        missions.count
    }

    var asSortedArray: [Dictionary<MissionTypeWrapper, any Mission>.Element] {
        Array(missions).sorted(by: { $0.key < $1.key })
    }

    init(missions: [MissionTypeWrapper: Mission] = [:]) {
        self.missions = missions
    }

    func addMission(for name: MissionTypeWrapper) {
        if let stats = missionsDataDelegate?.statisticsDatabase {
            missions[name] = MissionsFactory.createDefaultInstance(of: name.asString, with: stats)
        }
    }

    func getMission(for name: MissionTypeWrapper) -> Mission? {
        missions[name]
    }

    func setToDefault() {
        missions = MissionsFactory.getDefaultMissionsDatabase(missionsDataDelegate).missions
    }

    func updateAll(with stats: StatisticsDatabase) {
        missions.values.forEach { $0.update(with: stats) }
    }

}
