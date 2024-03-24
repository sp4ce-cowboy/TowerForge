//
//  Spawnable.swift
//  TowerForge
//
//  Created by Vanessa Mae on 19/03/24.
//

import Foundation

protocol PlayerSpawnable: Spawnable {
    static var cost: Int { get set }
    static var title: String { get }
}
