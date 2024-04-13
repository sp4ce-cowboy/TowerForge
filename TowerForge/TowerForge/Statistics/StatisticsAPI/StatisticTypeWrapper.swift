//
//  StatisticTypeWrapper.swift
//  TowerForge
//
//  Created by Rubesh on 13/4/24.
//

import Foundation

/// A wrapper for the concrete type of Statistic.
///
/// Allows the type itself to be used as a hashable key in a dictionary
struct StatisticTypeWrapper: Equatable, Hashable {
    let type: Statistic.Type

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}
