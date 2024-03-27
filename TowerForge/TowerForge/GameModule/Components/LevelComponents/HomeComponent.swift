//
//  HomeComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import QuartzCore

class HomeComponent: TFComponent {
    var lifeLeft: Int {
        didSet {
            // Update the life left in the LabelComponent when it changes
            guard let labelComponent = entity?.component(ofType: LabelComponent.self),
                  labelComponent.name == "life" else {
                return
            }
            labelComponent.changeText(String(lifeLeft))
        }
    }
    var points = 0 {
        didSet {
            // Update the points in the LabelComponent when it changes
            guard let labelComponent = entity?.component(ofType: LabelComponent.self),
                  labelComponent.name == "point" else {
                return
            }
            labelComponent.changeText(String(points))
        }
    }
    private var lastPointIncrease = TimeInterval(0)
    private var pointInterval: TimeInterval
    private var pointsPerInterval: Int = 1
    init(initialLifeCount: Int, pointInterval: TimeInterval) {
        self.lifeLeft = initialLifeCount
        self.pointInterval = pointInterval
        super.init()
    }
    func decreaseLife(by amount: Int) -> Int {
        self.lifeLeft -= amount
        return self.lifeLeft
    }
    func increaseLife(by amount: Int) -> Int {
        self.lifeLeft += amount
        return self.lifeLeft
    }
    func decreasePoints(_ amount: Int) {
        self.points -= amount
    }
    func increasePoints(_ amount: Int) {
        self.points += amount
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
