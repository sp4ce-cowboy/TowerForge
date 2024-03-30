//
//  TFScene.swift
//  TowerForge
//
//  Created by Zheng Ze on 30/3/24.
//

import Foundation

protocol TFScene: AnyObject {
    var updateDelegate: SceneUpdateDelegate? { get set }
    var size: CGSize { get set }

    func add(node: TFNode, staticOnScreen: Bool)
    func remove(node: TFNode)
    func contains(node: TFNode) -> Bool

    func setBounds(_ bounds: CGRect)
    func panCamera(by displacement: CGVector)
}
