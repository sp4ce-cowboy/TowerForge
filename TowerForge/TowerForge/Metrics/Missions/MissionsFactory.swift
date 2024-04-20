//
//  MissionsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

class MissionsFactory {

    static var availableMissionTypes: [String: Mission.Type] =
        [
            String(describing: MassDamageMission.self): MassDamageMission.self,
            String(describing: MassKillMission.self): MassKillMission.self,
            String(describing: MassDeathMission.self): MassDeathMission.self
        ]

    static func registerMissionType<T: Mission>(_ stat: T) {
        availableMissionTypes[String(describing: T.self)] = T.self
    }

    static func getDefaultMissionsDatabase(_ data: InferenceDataDelegate?) -> MissionsDatabase {
        let missionsDatabase = MissionsDatabase()
        missionsDatabase.missionsDataDelegate = data
        availableMissionTypes.values.forEach { missionsDatabase.addMission(for: $0.asType) }
        return missionsDatabase
    }

    static func createDefaultInstance(of typeName: String, with db: StatisticsDatabase) -> Mission? {
        guard let type = availableMissionTypes[typeName] else {
            return nil
        }

        let stats: [Statistic] = db.statistics.values.filter { key in
            type.definedParameters.keys.contains {
                $0 == key.statisticName
            }
        }

        return type.init(dependentStatistics: stats)
    }
}
