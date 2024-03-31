//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storage class encapsulates a specific type of Storable item.
/// It also enforces type consistency to ensure that only one type of
/// storable item type is contained within itself at all times.

protocol Storage: Codable {

    var storageName: StorageEnums.StorageType { get set }
    var storedObjects: [UUID: Storable] { get set }

    init(storageName: StorageEnums.StorageType, files: [UUID: Storable])
}

extension Storage {

    static func generateStoredObjectsCollection(_ storedObjects: [any Storable]) -> [UUID: any Storable] {
        var storedObjectsMap: [UUID: any Storable] = [:]

        for storable in storedObjects {
            storedObjectsMap[storable.storableId] = storable
        }

        return storedObjectsMap
    }
}

/*class Storage<T: Storable>: Codable where T.DataType: Codable {
    var storedFiles: [T] = []
    
    init(_ files: [T] = []) {
        self.storedFiles = files
    }
    
    enum CodingKeys: String, CodingKey {
        case storedFiles
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the array of `T` which conforms to `Storable`.
        // This leverages the custom decoding logic defined in the `Storable` extension.
        self.storedFiles = try container.decode([T].self, forKey: .storedFiles)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the array of `T`, leveraging the custom encoding logic defined in the `Storable` extension.
        try container.encode(storedFiles, forKey: .storedFiles)
    }
}*/
