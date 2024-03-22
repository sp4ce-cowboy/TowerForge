//
//  SceneUpdateDelegate.swift
//  TowerForge
//
//  Created by Zheng Ze on 20/3/24.
//

import Foundation

protocol SceneUpdateDelegate: AnyObject {
    func update(deltaTime: TimeInterval)
    func touch(at location: CGPoint)
    func contactBegin(between nodeA: TFSpriteNode, and nodeB: TFSpriteNode)
    func contactEnd(between nodeA: TFSpriteNode, and nodeB: TFSpriteNode)
}
