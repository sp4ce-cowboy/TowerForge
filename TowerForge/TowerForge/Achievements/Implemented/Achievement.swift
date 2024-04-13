//
//  Achievement.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

/// Achievement protocol that conforms to Storable and can be stored within
/// Storage.
///
/// TODO: Replace current storable with generic storable that can
/// support Achievement
protocol Achievement: Storable {

}

extension Achievement {
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
