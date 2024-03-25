//
//  Renderable.swift
//  TowerForge
//
//  Created by Zheng Ze on 21/3/24.
//

import Foundation

protocol Renderable: AnyObject {
    func entitiesToRender() -> [TFEntity]
}
