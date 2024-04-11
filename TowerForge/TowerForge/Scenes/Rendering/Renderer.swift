//
//  Renderer.swift
//  TowerForge
//
//  Created by Zheng Ze on 10/4/24.
//

import Foundation

protocol Renderer: AnyObject {
    func render()
    func renderMessage(_ message: String)
}
