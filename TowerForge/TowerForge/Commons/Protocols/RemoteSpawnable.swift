//
//  RemoteSpawnable.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation

protocol RemoteSpawnable: Spawnable {
    init(position: CGPoint, player: Player, id: UUID)
}
