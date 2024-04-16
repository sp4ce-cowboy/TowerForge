//
//  InferenceEngineType.swift
//  TowerForge
//
//  Created by Rubesh on 16/4/24.
//

import Foundation

struct InferenceEngineTypeWrapper: Equatable, Hashable {
    let type: InferenceEngine.Type

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
