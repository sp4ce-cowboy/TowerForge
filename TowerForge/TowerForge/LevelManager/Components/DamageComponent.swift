//
//  DamageComponent.swift
//  TowerForge
//
//  Created by MacBook Pro on 15/03/24.
//

import Foundation

class DamageComponent: TFComponent {
    // Defines the damage that should be dealt on collision
    public var damage: CGFloat

    init(damage: CGFloat) {
        self.damage = damage
        super.init()
    }
}
