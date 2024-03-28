//
//  GameMode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

protocol GameMode {
    var modeName: String { get }
    var modeDescription: String { get }
    
    func startGame()
    func pauseGame()
    func winGame()
    func endGame()
}
