//
//  Grid.swift
//  TowerForge
//
//  Created by Keith Gan on 22/3/24.
//

import SpriteKit

class Grid: GridDelegate {
    let DEFAULT_NO_OF_ROWS = 5
    let UNIT_SELECTION_NODE_HEIGHT = CGFloat(200)

    private var noOfRows: Int
    private var width: CGFloat
    private var height: CGFloat

    init(screenSize: CGRect) {
        self.noOfRows = DEFAULT_NO_OF_ROWS
        self.width = screenSize.width
        self.height = screenSize.height
    }

    func generateTileMap(scene: SKScene) {
        let screenWidth = self.width
        let screenHeight = self.height - UNIT_SELECTION_NODE_HEIGHT
        let tileSize = CGSize(width: screenHeight / CGFloat(noOfRows), height: screenHeight / CGFloat(noOfRows))

        // Calculate the number of columns needed to cover the screen width
        let numberOfColumns = Int(ceil(screenWidth / tileSize.width))

        for row in 0..<noOfRows {
            for col in 0..<numberOfColumns {
                let node = TFSpriteNode(imageName: "road-tile", size: tileSize)
                node.anchorPoint = CGPoint(x: 0, y: 0)
                node.position = CGPoint(x: CGFloat(CGFloat(col) * tileSize.width),
                                        y: CGFloat(CGFloat(row) * tileSize.height) + UNIT_SELECTION_NODE_HEIGHT)
                node.zPosition = -100
                scene.addChild(node.node)
            }
        }
    }

    func snapYPosition(yPosition: Double) -> Double {
        let screenHeight = Double(UIScreen.main.bounds.height) - UNIT_SELECTION_NODE_HEIGHT
        let rowHeight = screenHeight / Double(noOfRows)
        let rowIndex = Int((yPosition - UNIT_SELECTION_NODE_HEIGHT) / rowHeight)
        let centerY = (Double(rowIndex) * rowHeight + rowHeight / 2) + UNIT_SELECTION_NODE_HEIGHT
        return centerY
    }
}
