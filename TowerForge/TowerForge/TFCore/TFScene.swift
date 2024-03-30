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
    var isHorizontallyPannable: Bool { get set }
    var isVerticallyPannable: Bool { get set }

    func add(node: TFNode, staticOnScreen: Bool)
    func remove(node: TFNode)
    func contains(node: TFNode) -> Bool

    func panCamera(by displacement: CGVector)
}
