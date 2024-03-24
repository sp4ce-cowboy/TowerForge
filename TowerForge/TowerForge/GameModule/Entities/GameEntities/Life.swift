//
//  Life.swift
//  TowerForge
//
//  Created by Vanessa Mae on 24/03/24.
//

import Foundation

class Life: TFEntity {
    static let position = CGPoint(x: 300, y: 100)
    init(initialLife: Int) {
        super.init()
        self.addComponent(SpriteComponent(textureNames: ["Life"],
                                          height: 100,
                                          width: 100,
                                          position: Life.position,
                                          animatableKey: "life"))
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(LabelComponent(text: String(initialLife), name: "life"))
        self.addComponent(PositionComponent(position: Life.position))
        self.addComponent(PlayerComponent(player: .ownPlayer))
    }
}
