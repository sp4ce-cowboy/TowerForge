//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 27/3/24.
//

import Foundation

final class Storage: Codable {
    var storedFiles: [Storable] = []
    
    func encode(to encoder: any Encoder) throws {
        return
    }
    
    init(from decoder: any Decoder) throws {
        return
    }
}
