//
//  GoalTypeWrapper.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

struct AbstractGoalTypeWrapper: Equatable, Hashable {
    let type: AbstractGoal.Type

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
