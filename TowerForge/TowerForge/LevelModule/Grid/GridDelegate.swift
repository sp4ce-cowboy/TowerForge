//
//  GridDelegate.swift
//  TowerForge
//
//  Created by Keith Gan on 24/3/24.
//

import SpriteKit

protocol GridDelegate: AnyObject {
    var UNIT_SELECTION_NODE_HEIGHT: CGFloat { get }
    func snapYPosition(yPosition: Double) -> Double
}
