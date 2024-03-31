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
    var gameProps: [any GameProp] { get }
    var gameState: GameState { get set }
    var eventManager: EventManager { get set }
    func updateGame()
    func startGame()
    func pauseGame()
    func winGame()
    func resumeGame()
}
