//
//  ContactComponent.swift
//  TowerForge
//
//  Created by Zheng Ze on 26/3/24.
//

import Foundation

class ContactComponent: TFComponent {
    let hitboxSize: CGSize

    init(hitboxSize: CGSize) {
        self.hitboxSize = hitboxSize
    }

    func hitbox(position: CGPoint) -> CGRect {
        CGRect(origin: position, size: hitboxSize)
    }
}
