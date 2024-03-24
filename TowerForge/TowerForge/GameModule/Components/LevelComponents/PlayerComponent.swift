//
//  PlayerComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import Foundation
import SpriteKit

class PlayerComponent: TFComponent {
    var player: Player
    init(player: Player) {
        self.player = player
        super.init()
    }
}

public enum Player: Int {
    case ownPlayer = 1
    case oppositePlayer = 2

    func getOppositePlayer() -> Player {
        switch self {
        case .ownPlayer:
            return .oppositePlayer
        case .oppositePlayer:
            return .ownPlayer
        }
    }

    func getDirectionVelocity() -> CGVector {
        switch self {
        case .ownPlayer:
            return CGVector(dx: 1.0, dy: 0.0)
        case .oppositePlayer:
            return CGVector(dx: -1.0, dy: 0.0)
        }
    }
}
