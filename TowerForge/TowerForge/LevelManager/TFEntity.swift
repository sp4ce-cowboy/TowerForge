//
//  TFEntity.swift
//  TowerForge
//
//  Created by MacBook Pro on 14/03/24.
//

import Foundation

class TFEntity {
    let id: UUID
    var components: [TFComponent]

    init() {
        id = UUID()
        components = []
    }
}
