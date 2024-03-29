//
//  Timer.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation
import UIKit

class Timer: TFEntity {
    static let position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.maxY - 200)
    static let size = CGSize(width: 100, height: 100)

    var remainingTime: TimeInterval {
        guard let timerComponent = self.component(ofType: TimerComponent.self) else {
            return 0 // Return default value if TimerComponent is not found
        }
        return timerComponent.time
    }

    init(timeLength: TimeInterval) {
        super.init()
        let timerComponent = TimerComponent(timeLength: timeLength)
        self.addComponent(SpriteComponent(textureNames: ["timer"], size: Timer.size, animatableKey: "timer"))
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(LabelComponent(text: String(0), name: "timer"))
        self.addComponent(timerComponent)
        self.addComponent(PositionComponent(position: Timer.position))
        self.addComponent(PlayerComponent(player: .ownPlayer))
    }
}
