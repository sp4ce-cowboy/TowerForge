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

    var toString: String {
        String(describing: type)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }

}

/// This extension allows the wrapped type to be written to and read from file
extension StatisticTypeWrapper: Codable {
    enum CodingKeys: String, CodingKey {
        case typeName
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let typeName = String(describing: type)
        try container.encode(typeName, forKey: .typeName)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try container.decode(String.self, forKey: .typeName)

        guard let type = NSClassFromString(typeName) as? Statistic.Type else {
            throw DecodingError.dataCorruptedError(forKey: .typeName,
                                                   in: container,
                                                   debugDescription: "Cannot decode Statistic.Type from \(typeName)")
        }

        self.type = type
    }
}
