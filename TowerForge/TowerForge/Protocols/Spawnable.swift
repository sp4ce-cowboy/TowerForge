//
//  Spawnable.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation

protocol Spawnable {
    init(position: CGPoint, entityManager: EntityManager, player: Player)
    static var cost: Int { get set }
    static var title: String { get }
}
