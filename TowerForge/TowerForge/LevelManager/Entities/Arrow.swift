//
//  Arrow.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class Arrow: BaseProjectile {
    static let textureNames: [String] = []
    static let size = CGSize(width: 10, height: 10)
    static let key = "arrow"
    static let damage = 5.0

    init(position: CGPoint, velocity: CGVector) {
        super.init(textureNames: Arrow.textureNames,
                   size: Arrow.size,
                   key: Arrow.key,
                   position: position,
                   velocity: velocity)
        self.addComponent(DamageComponent(damage: Arrow.damage))
    }
}
