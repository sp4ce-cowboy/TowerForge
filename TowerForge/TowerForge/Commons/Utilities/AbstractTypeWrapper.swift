//
//  AbstractTypeWrapper.swift
//  TowerForge
//
//  Created by Rubesh on 18/4/24.
//

import Foundation

/// TODO: Replace type wrappers with this.
protocol AbstractTypeWrapper: Equatable, Hashable {
    associatedtype T: Any
    var type: T.Type { get }

    var asString: String { get }
}

struct GenericTypeWrapper<T>: AbstractTypeWrapper {
    let type: T.Type

    var asString: String {
        String(describing: type)
    }

    static func == (lhs: GenericTypeWrapper<T>, rhs: GenericTypeWrapper<T>) -> Bool {
        lhs.type == rhs.type
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}

extension GenericTypeWrapper: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let typeName = self.asString
        try container.encode(typeName)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let typeName = try container.decode(String.self)

        guard let statType = typeName.asTFClassFromString as? T.Type else {
            Logger.log("Error at decoding StatisticType", Self.self)

            let context = DecodingError.Context(codingPath: container.codingPath,
                                                debugDescription: "Cannot decode \(typeName) as Statistic.Type")

            throw DecodingError.typeMismatch(T.Type.self, context)
        }

        self.type = statType
    }
}

protocol TypeRepresentable: AnyObject {
    static var asType: GenericTypeWrapper<Self> { get }
}

extension TypeRepresentable {
    static var asType: GenericTypeWrapper<Self> {
        GenericTypeWrapper(type: Self.self)
    }
}
