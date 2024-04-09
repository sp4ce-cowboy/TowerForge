//
//  DeathProp.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class DeathProp: GameProp {
    var renderableEntity: Death

    init(position: CGPoint, player: Player) {
        self.renderableEntity = Death(position: position, player: player)

    }
}
