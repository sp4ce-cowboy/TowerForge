//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

/// The Storage class encapsulates a specific type of Storable 
final class Storage: Codable {
    var storedFiles: [any Storable] = []

    init(_ files: [any Storable] = []) {
        storedFiles = files
    }

    func encode(to encoder: any Encoder) throws {

    }

    init(from decoder: any Decoder) throws {

    }
}
