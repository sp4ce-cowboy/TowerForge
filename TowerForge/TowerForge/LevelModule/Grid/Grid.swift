//
//  Grid.swift
//  TowerForge
//
//  Created by Keith Gan on 22/3/24.
//

import SpriteKit

class Grid: GridDelegate {
    static let DEFAULT_NUM_ROWS = 5
    let UNIT_SELECTION_NODE_HEIGHT = CGFloat(200)
    let playableBounds: CGRect

    private let numRows: Int
    private var numCols: Int { Int(ceil(screenWidth / tileSize.width)) }
    private var screenWidth: CGFloat { playableBounds.width }
    private var screenHeight: CGFloat { playableBounds.height - UNIT_SELECTION_NODE_HEIGHT }
    private var tileSize: CGSize { CGSize(width: screenHeight / CGFloat(numRows),
                                          height: screenHeight / CGFloat(numRows)) }

    init(screenSize: CGRect, numRows: Int = Grid.DEFAULT_NUM_ROWS) {
        self.playableBounds = screenSize
        self.numRows = numRows
    }

    func generateTileMap(scene: SKScene) {
        let tileSize = self.tileSize
        for row in 0..<numRows {
            for col in 0..<numCols {
                let node = TFSpriteNode(imageName: "road-tile", size: tileSize)
                let position = CGPoint(x: CGFloat(col) * tileSize.width,
                                       y: CGFloat(row) * tileSize.height + UNIT_SELECTION_NODE_HEIGHT)
                node.anchorPoint = CGPoint(x: 0, y: 0)
                node.position = normaliseToPlayableBounds(position: position)
                node.zPosition = -100
                scene.addChild(node.node)
            }
        }
    }

    func snap(position: CGPoint) -> CGPoint {
        let rowIndex = Int((position.y - UNIT_SELECTION_NODE_HEIGHT) / tileSize.height)
        let colIndex = Int(position.x / tileSize.width)

        let centerY = (Double(rowIndex) + 0.5) * tileSize.height + UNIT_SELECTION_NODE_HEIGHT
        let centerX = (Double(colIndex) + 0.5) * tileSize.width
        return CGPoint(x: centerX, y: centerY)
    }

    private func normaliseToPlayableBounds(position: CGPoint) -> CGPoint {
        CGPoint(x: position.x + playableBounds.minX, y: position.y + playableBounds.minY)
    }
}
