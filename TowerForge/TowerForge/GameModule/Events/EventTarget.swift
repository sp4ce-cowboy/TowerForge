//
//  EventTarget.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

protocol EventTarget: AnyObject {
    var gameMode: GameMode { get }
    func system<T: TFSystem>(ofType type: T.Type) -> T?
}
