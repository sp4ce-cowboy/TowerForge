//
//  UnitGenerator.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation

class UnitGenerator {
    static func spawn<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, at position: CGPoint, player: Player) -> T {
        let unit = type.init(position: position, player: player)
        return unit
    }
}
