//
//  PlayerComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import Foundation
import SpriteKit

enum Player: Int {
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

class PlayerComponent: TFComponent {
    public var player: Player
    public var lifeLeft: Int
    public var points = 0
    private var lastPointIncrease = TimeInterval(0)
    private var pointInterval: TimeInterval
    private var pointsPerInterval: Int = 10
    
    init(player: Player, initialLifeCount: Int, pointInterval: TimeInterval) {
        self.player = player
        self.lifeLeft = initialLifeCount
        self.pointInterval = pointInterval
        super.init()
    }
    
    func decreaseLife() -> Int {
        self.lifeLeft -= 1
        return self.lifeLeft
    }
    
    func increaseLife() -> Int {
        self.lifeLeft += 1
        return self.lifeLeft
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        
        // Points update
        if(CACurrentMediaTime() - lastPointIncrease > pointInterval) {
            lastPointIncrease = CACurrentMediaTime()
            points += self.pointsPerInterval
        }
    }
}


