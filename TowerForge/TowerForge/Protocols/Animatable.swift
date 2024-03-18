//
//  Animatable.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation
import SpriteKit

protocol Animatable {
    var animatableAction: SKAction? { get set }
    var animatableKey: String { get set }

    func playAnimation()
    func stopAnimation()
}
