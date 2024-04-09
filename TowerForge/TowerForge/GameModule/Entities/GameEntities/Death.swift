//
//  Death.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class Death: TFEntity {
    init(position: CGPoint, player: Player) {
        super.init()
        let spriteComponent = SpriteComponent(textureNames: ["Skull"],
                                              size: SizeConstants.DEATH_MATCH_POINT_SIZE,
                                              animatableKey: "death")

        self.addComponent(spriteComponent)
        self.addComponent(LabelComponent(text: String(0), name: "killCount"))
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount,
                                        pointInterval: Team.pointsInterval))
        self.addComponent(PositionComponent(position: position))
        self.addComponent(PlayerComponent(player: player))

        spriteComponent.staticOnScreen = true
    }
}
