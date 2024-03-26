//
//  Point.swift
//  TowerForge
//
//  Created by Vanessa Mae on 23/03/24.
//

import Foundation

class Point: TFEntity {
    static let position = CGPoint(x: 100, y: 100)
    static let size = CGSize(width: 100, height: 100)
    init(initialPoint: Int) {
        super.init()
        self.addComponent(SpriteComponent(textureNames: ["Coin"], size: Point.size, animatableKey: "point"))
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(LabelComponent(text: String(initialPoint), name: "point"))
        self.addComponent(PositionComponent(position: Point.position))
        self.addComponent(PlayerComponent(player: .ownPlayer))
    }
}
