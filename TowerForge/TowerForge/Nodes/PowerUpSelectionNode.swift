//
//  PowerUpSelectionNode.swift
//  TowerForge
//
//  Created by Keith Gan on 31/3/24.
//

import Foundation
import UIKit

class PowerUpSelectionNode: TFEntity {
    private var eventManager: EventManager?
    private(set) var powerupNodes: [PowerUpNode] = []

    init(eventManager: EventManager) {
        super.init()
        let possiblePowerUps: [PowerUp] = PowerUp.allPowerUps
        var startingPoint = CGPoint(x: UIScreen.main.bounds.maxX - PowerUpNode.size.width / 2,
                                    y: PowerUpNode.size.height / 2)

        for type in possiblePowerUps {
            let delegate = PowerUpDelegateFactory.createPowerUpDelegate(type: type, eventManager: eventManager)
            let powerUpNode = PowerUpNode(type: type, delegate: delegate, at: startingPoint)
            powerupNodes.append(powerUpNode)
            startingPoint.x -= PowerUpNode.size.width
        }
        self.addComponent(PlayerComponent(player: .ownPlayer))
    }
}
