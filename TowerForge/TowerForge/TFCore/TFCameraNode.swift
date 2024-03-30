//
//  TFCameraNode.swift
//  TowerForge
//
//  Created by Zheng Ze on 30/3/24.
//

import SpriteKit

class TFCameraNode: TFNode {
    private var minX: CGFloat = .zero
    private var maxX: CGFloat = .zero
    private var minY: CGFloat = .zero
    private var maxY: CGFloat = .zero

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

    func setBounds(_ bounds: CGRect) {
        let size = UIScreen.main.bounds.size

        self.minX = bounds.minX + size.width / 2
        self.maxX = bounds.maxX - size.width / 2
        self.minY = bounds.minY + size.height / 2
        self.maxY = bounds.maxY - size.height / 2
    }

    override func move(by displacement: CGVector) {
        super.move(by: displacement)

        position.x = max(position.x, minX)
        position.x = min(position.x, maxX)
        position.y = max(position.y, minY)
        position.y = min(position.y, maxY)
    }
}
