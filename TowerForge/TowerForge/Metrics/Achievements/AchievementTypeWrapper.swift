//
//  AchievementTypeWrapper.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

struct AchievementTypeWrapper: Equatable, Hashable {
    let type: Achievement.Type

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
