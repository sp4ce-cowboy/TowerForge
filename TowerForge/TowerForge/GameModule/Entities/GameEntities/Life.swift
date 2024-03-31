//
//  Life.swift
//  TowerForge
//
//  Created by Vanessa Mae on 24/03/24.
//

import Foundation

class Life: TFEntity {
    static let position = CGPoint(x: 300, y: 100)
    static let size = CGSize(width: 100, height: 100)
    init(initialLife: Int) {
        super.init()
        let spriteComponent = SpriteComponent(textureNames: ["Life"], size: Life.size, animatableKey: "life")

        self.addComponent(spriteComponent)
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(LabelComponent(text: String(initialLife), name: "life"))
        self.addComponent(PositionComponent(position: Life.position))
        self.addComponent(PlayerComponent(player: .ownPlayer))

        spriteComponent.staticOnScreen = true
    }
}
