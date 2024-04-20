//
//  Point.swift
//  TowerForge
//
//  Created by Vanessa Mae on 23/03/24.
//

import Foundation

class Point: TFEntity {
    init(initialPoint: Int) {
        super.init()
        let spriteComponent = SpriteComponent(textureNames: ["Coin"], size: SizeConstants.POINT_SIZE,
                                              animatableKey: "point")

        self.addComponent(spriteComponent)
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(LabelComponent(text: String(initialPoint), name: "point"))
        self.addComponent(PositionComponent(position: PositionConstants.POINTS_OWN))
        self.addComponent(PlayerComponent(player: .ownPlayer))

        spriteComponent.staticOnScreen = true
    }
}
