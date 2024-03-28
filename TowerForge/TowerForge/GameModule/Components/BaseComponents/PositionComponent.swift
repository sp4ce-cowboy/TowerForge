//
//  PositionComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import Foundation
import CoreGraphics
import UIKit

class PositionComponent: TFComponent {
    private(set) var position: CGPoint
    var anchorPoint: CGPoint

    init(position: CGPoint, anchorPoint: CGPoint) {
        self.position = position
        self.anchorPoint = anchorPoint
        super.init()
    }

    convenience init(position: CGPoint) {
        self.init(position: position, anchorPoint: CGPoint(x: 0, y: 0))
    }

    func changeTo(to position: CGPoint) {
        self.position = position
    }

    func move(by displacement: CGVector) {
        position.x += displacement.dx
        position.y += displacement.dy
    }
}
