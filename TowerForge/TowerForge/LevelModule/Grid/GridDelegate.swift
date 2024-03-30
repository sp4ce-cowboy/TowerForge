//
//  GridDelegate.swift
//  TowerForge
//
//  Created by Keith Gan on 24/3/24.
//

import QuartzCore

protocol GridDelegate: AnyObject {
    var UNIT_SELECTION_NODE_HEIGHT: CGFloat { get }
    var playableBounds: CGRect { get }
    var tileSize: CGSize { get }
    func snap(position: CGPoint) -> CGPoint
}
