//
//  StorageEnums.swift
//  TowerForge
//
//  Created by Rubesh on 31/3/24.
//

import Foundation

class StorageEnums {

    /// An enum for the names of every Storable that can be stored.
    /// Adds an implicit "CheckRep", malicious actors cannot load
    /// random storables perhaps using obj-c's dynamic runtime.
    enum StorableNameType: String, CodingKey, CaseIterable, Codable {
        case dummy // Temp dummy case to replace later
    }

    enum StorableDefaultCodingKeys: String, CodingKey {
        case storableId
        case storableName
        case storableValue
    }
    
    enum StorageType: String, CodingKey {
        case achievementStorage
    }
}
