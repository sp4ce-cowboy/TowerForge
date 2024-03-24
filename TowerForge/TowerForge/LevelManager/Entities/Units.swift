//
//  Units.swift
//  TowerForge
//
//  Created by MacBook Pro on 24/03/24.
//

import Foundation

class Units: TFEntity {
    static let position = CGPoint(x: 300, y: 100)
    let selectionNode: UnitSelectionNode
    override init() {
        self.selectionNode = UnitSelectionNode()
        super.init()

        self.addComponent(SpriteComponent(node: selectionNode))
        self.addComponent(HomeComponent(initialLifeCount: Team.lifeCount, pointInterval: Team.pointsInterval))
        self.addComponent(PositionComponent(position: CGPoint(x: 500, y: self.selectionNode.height / 2)))
        self.addComponent(PlayerComponent(player: .ownPlayer))

    }
}
