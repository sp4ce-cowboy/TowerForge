//
//  SceneManagerDelegate.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import Foundation

protocol SceneManagerDelegate {
    func showMenuScene()
    func showLevelScene()
    func showGameLevelScene(level: Int)
}
