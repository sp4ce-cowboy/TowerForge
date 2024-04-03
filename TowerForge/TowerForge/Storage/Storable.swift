//
//  Storable.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storable protocol adds a layer between Swift's Codable and elements
/// in TowerForge that requires storage. Each Storable has a UUID base, a
/// storableName, and a storable Value. The storable value can differ based
/// on the value that is needed to be stored.
///
/// All storableNames must be "registered" within the StorableNames enum inside
/// the StorageEnums class, this ensures that no arbitrary items are stored and
/// the things needed to be stored in the context of TowerForge will all be
/// pre-determined before runtime.
typealias TFStorableType = StorageEnums.StorableNameType
protocol Storable: Codable {

    var storableId: UUID { get set }
    var storableName: TFStorableType { get set }
    var storableValue: Double { get set }

    init(id: UUID, name: TFStorableType, value: Double)
}

/// This extension adds a default implementation for Storables that do not
/// have any concrete extensions.
///
/// Swift automatically synthesizes encoder and decoders for standard library
/// types such as String, Double and Id. However, it cannot always be ensured
/// that the types contained within a Storable will be of that particular type.
///
/// Thus, this explicit declaration allows us to fine tune the values to be
/// encoded and decoded.
extension Storable {
    func encode(to encoder: any Encoder) throws {
        Logger.log("Storable Default encode function called", (any Storable).self)
        var container = encoder.container(keyedBy: StorageEnums.StorableDefaultCodingKeys.self)
        try container.encode(storableId, forKey: .storableId)
        try container.encode(storableName, forKey: .storableName)
        try container.encode(storableValue, forKey: .storableValue)
    }

    init(from decoder: any Decoder) throws {
        Logger.log("Storable default decoder init called", (any Storable).self)
        let container = try decoder.container(keyedBy: StorageEnums.StorableDefaultCodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .storableId)
        let name = try container.decode(TFStorableType.self, forKey: .storableName)
        let value = try container.decode(Double.self, forKey: .storableValue)

        self.init(id: id, name: name, value: value)
    }
}
