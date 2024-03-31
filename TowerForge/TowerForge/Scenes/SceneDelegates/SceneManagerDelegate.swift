//
//  SceneManagerDelegate.swift
//  TowerForge
//
//  Created by Vanessa Mae on 20/03/24.
//

import Foundation

protocol SceneManagerDelegate: AnyObject {
    func showMenuScene()
    func showGameOverScene(isWin: Bool)
    func showLevelScene()
    func showGameLevelScene(level: Int)
}
