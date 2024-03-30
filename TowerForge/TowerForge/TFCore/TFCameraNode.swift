//
//  TFCameraNode.swift
//  TowerForge
//
//  Created by Zheng Ze on 30/3/24.
//

import SpriteKit

class TFCameraNode: TFNode {
    override init() {
        super.init()
        node = SKCameraNode()
    }

    var cameraNode: SKCameraNode {
        guard let cameraNode = node as? SKCameraNode else {
            fatalError("SKNode in TFNode was not a SKCameraNode")
        }
        return cameraNode
    }

    func contains(_ node: TFNode) -> Bool {
        cameraNode.contains(node.node)
    }
}
