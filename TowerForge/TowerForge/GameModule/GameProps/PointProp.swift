//
//  PointProp.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class PointProp: GameProp {
    var renderableEntity: Point

    init(initialPoint: Int) {
        self.renderableEntity = Point(initialPoint: initialPoint)
    }
}
