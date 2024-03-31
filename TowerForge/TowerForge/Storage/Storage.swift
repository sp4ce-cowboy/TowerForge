//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

final class Storage: Codable {
    var storedFiles: [Storable] = []

    init(_ files: [Storable] = []) {
        storedFiles = files
    }

    func encode(to encoder: any Encoder) throws {

    }

    init(from decoder: any Decoder) throws {

    }
}
