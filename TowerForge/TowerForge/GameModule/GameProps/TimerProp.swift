//
//  TimerProp.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class TimerProp: GameProp {
    var renderableEntity: Timer
    var time: TimeInterval {
        self.renderableEntity.remainingTime
    }
    init(timeLength: TimeInterval) {
        self.renderableEntity = Timer(timeLength: timeLength)
    }
}
