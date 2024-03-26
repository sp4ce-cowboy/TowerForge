//
//  PointProp.swift
//  TowerForge
//
//  Created by MacBook Pro on 27/03/24.
//

import Foundation

class PointProp: GameProp {
    var renderableEntity: TFEntity
    
    init(initialPoint: Int) {
        self.renderableEntity = Point(initialPoint: initialPoint)
    }
}
