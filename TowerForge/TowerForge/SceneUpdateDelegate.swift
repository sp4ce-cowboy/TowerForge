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
    func contactBegin(between nodeA: TFAnimatableNode, and nodeB: TFAnimatableNode)
    func contactEnd(between nodeA: TFAnimatableNode, and nodeB: TFAnimatableNode)
}
