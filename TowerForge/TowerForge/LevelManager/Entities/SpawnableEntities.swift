//
//  Entities.swift
//  TowerForge
//
//  Created by Zheng Ze on 21/3/24.
//

import Foundation

struct SpawnableEntities {
    static let playerSpawnableEntities: [(TFEntity & PlayerSpawnable).Type] = [MeleeUnit.self, SoldierUnit.self]
}
