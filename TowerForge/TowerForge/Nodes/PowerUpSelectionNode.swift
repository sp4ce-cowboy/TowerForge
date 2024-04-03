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

    init(eventManager: EventManager) {
//        super.init()
//        let spriteComponent = SpriteComponent(textureNames: ["life"], size: CGSize.zero, animatableKey: "selectionNode")
//        let node = spriteComponent.node
//        node.isUserInteractionEnabled = true
//
//        let possiblePowerUps: [PowerUp] = PowerUp.allPowerUps
//        var startingPoint = CGPoint(x: 600, y: 0)
//
//        for type in possiblePowerUps {
//            let delegate = PowerUpDelegateFactory.createPowerUpDelegate(type: type, eventManager: eventManager)
//            let powerUpNode = PowerUpNode(type: type, delegate: delegate)
//            powerUpNode.position = startingPoint
//            node.addChild(powerUpNode)
//
//            startingPoint.x += 140
//        }
//
//        node.position = CGPoint(x: 500, y: 100)
//        self.addComponent(spriteComponent)
//        self.addComponent(PositionComponent(position: node.position))
//        self.addComponent(PlayerComponent(player: .ownPlayer))
    }
}
