//
//  MissionTypeWrapper.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

struct MissionTypeWrapper: Equatable, Hashable {
    let type: Mission.Type

    var asString: String {
        String(describing: type)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}
