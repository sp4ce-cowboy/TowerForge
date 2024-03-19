//
//  HomeComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation
import SpriteKit

class HomeComponent: TFComponent {
    var lifeLeft: Int
    var points = 0
    private var lastPointIncrease = TimeInterval(0)
    private var pointInterval: TimeInterval
    private var pointsPerInterval: Int = 10
    init(initialLifeCount: Int, pointInterval: TimeInterval) {
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
        if CACurrentMediaTime() - lastPointIncrease > pointInterval {
            lastPointIncrease = CACurrentMediaTime()
            points += self.pointsPerInterval
        }
    }
}
