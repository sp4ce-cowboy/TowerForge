//
//  TimerComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class TimerComponent: TFComponent {
    var time: TimeInterval
    init(timeLength: TimeInterval) {
        self.time = timeLength
        super.init()
    }
    override func update(deltaTime: TimeInterval) {
        self.time -= deltaTime
        guard let labelComponent = entity?.component(ofType: LabelComponent.self) else {
            return
        }
        labelComponent.changeText(String(self.time.rounded()))
    }
}
