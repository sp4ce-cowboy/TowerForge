//
//  LifeProp.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class LifeProp: GameProp {
    var renderableEntity: Life

    init(initialLife: Int) {
        self.renderableEntity = Life(initialLife: initialLife)
    }
}
