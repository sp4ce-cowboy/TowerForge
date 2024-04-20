//
//  MissionTypeWrapper.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

struct MissionTypeWrapper: Equatable, Hashable, Comparable {
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

    static func < (lhs: MissionTypeWrapper, rhs: MissionTypeWrapper) -> Bool {
        lhs.asString < rhs.asString
    }

    static func > (lhs: MissionTypeWrapper, rhs: MissionTypeWrapper) -> Bool {
        lhs.asString > rhs.asString
    }
}
