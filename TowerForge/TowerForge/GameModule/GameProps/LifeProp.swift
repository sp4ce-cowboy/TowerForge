//
//  LifeProp.swift
//  TowerForge
//
//  Created by MacBook Pro on 27/03/24.
//

import Foundation

class LifeProp: GameProp {
    var renderableEntity: TFEntity
    
    init(initialLife: Int) {
        self.renderableEntity = Life(initialLife: initialLife)
    }
}
