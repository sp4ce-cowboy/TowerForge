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

/// This extension allows the wrapped type to be written to and read from file
extension StatisticTypeWrapper: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let typeName = self.asString
        try container.encode(typeName)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let typeName = try container.decode(String.self)

        guard let statType = typeName.asTFClassFromString as? Statistic.Type else {
            Logger.log("Error at decoding StatisticType", Self.self)

            let context = DecodingError.Context(codingPath: container.codingPath,
                                                debugDescription: "Cannot decode \(typeName) as Statistic.Type")

            throw DecodingError.typeMismatch(Statistic.Type.self, context)
        }

        self.type = statType
    }
}
