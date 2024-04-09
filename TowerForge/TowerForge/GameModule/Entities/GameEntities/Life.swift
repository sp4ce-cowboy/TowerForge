//
//  Life.swift
//  TowerForge
//
//  Created by Vanessa Mae on 24/03/24.
//

import Foundation

class Life: TFEntity {
    init(initialLife: Int, position: CGPoint, player: Player) {
        super.init()
        let spriteComponent = SpriteComponent(textureNames: ["Life"],
                                              size: SizeConstants.CTF_POINT_SIZE,
                                              animatableKey: "life")
        self.addComponent(spriteComponent)
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(LabelComponent(text: String(initialLife),
                                         name: "life",
                                         subtitle: player == .ownPlayer ? "Your Life" : "Opponent Life"))
        self.addComponent(PositionComponent(position: position))
        self.addComponent(PlayerComponent(player: player))

        spriteComponent.staticOnScreen = true
    }
}
