//
//  Death.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class Death: TFEntity {
    static let position = CGPoint(x: 300, y: 100)
    static let size = CGSize(width: 100, height: 100)
    override init() {
        super.init()
        let spriteComponent = SpriteComponent(textureNames: ["Skull"], size: Death.size, animatableKey: "death")

        self.addComponent(spriteComponent)
        self.addComponent(LabelComponent(text: String(0), name: "killCount"))
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(PositionComponent(position: Death.position))
        self.addComponent(PlayerComponent(player: .ownPlayer))

        spriteComponent.staticOnScreen = true
    }
}
