//
//  Grid.swift
//  TowerForge
//
//  Created by Keith Gan on 22/3/24.
//

import SpriteKit

class Grid: UnitSelectionNodeDelegate {
    let DEFAULT_NO_OF_ROWS = 8

    private var eventManager: EventManager
    private var noOfRows: Int
    private var width: CGFloat
    private var height: CGFloat

    init(eventManager: EventManager, screenSize: CGRect) {
        self.eventManager = eventManager
        self.noOfRows = DEFAULT_NO_OF_ROWS
        self.width = screenSize.width
        self.height = screenSize.height
    }

    func unitSelectionNodeDidSpawn<T: TFEntity & PlayerSpawnable>(ofType type: T.Type, position: CGPoint) {
        let snapPosition = CGPoint(x: position.x, y: snapYPosition(yPosition: position.y))
        eventManager.add(RequestSpawnEvent(ofType: type, timestamp: CACurrentMediaTime(),
                                           position: snapPosition, player: .ownPlayer))
    }

    func generateTileMap(scene: SKScene) {
        let screenWidth = self.width
        let screenHeight = self.height
        let tileSize = CGSize(width: screenHeight / CGFloat(noOfRows), height: screenHeight / CGFloat(noOfRows))

        // Calculate the number of columns needed to cover the screen width
        let numberOfColumns = Int(ceil(screenWidth / tileSize.width))

        for row in 0..<noOfRows {
            for col in 0..<numberOfColumns {
                let node = TFSpriteNode(imageName: "road-tile", height: tileSize.height, width: tileSize.width)
                node.anchorPoint = CGPoint(x: 0, y: 0)
                node.position = CGPoint(x: CGFloat(CGFloat(col) * tileSize.width),
                                        y: CGFloat(CGFloat(row) * tileSize.height))
                node.zPosition = -100
                scene.addChild(node)
            }
        }
    }

    private func snapYPosition(yPosition: Double) -> Double {
        let normalizedYPosition = normalizeYPosition(yPosition: yPosition)
        let screenHeight = Double(UIScreen.main.bounds.height)
        let rowHeight = screenHeight / Double(noOfRows)
        let rowIndex = Int(normalizedYPosition / rowHeight)
        let centerY = Double(rowIndex) * rowHeight + rowHeight / 2
        return denormalizeYPosition(yPosition: centerY)
    }

    private func normalizeYPosition(yPosition: Double) -> Double {
        yPosition
    }

    private func denormalizeYPosition(yPosition: Double) -> Double {
        yPosition
    }
}
