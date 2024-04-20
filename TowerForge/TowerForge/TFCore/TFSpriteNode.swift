//
//  TFNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation
import SpriteKit

class TFSpriteNode: TFNode {
    var anchorPoint: CGPoint {
        get { spriteNode.anchorPoint }
        set(anchorPoint) { spriteNode.anchorPoint = anchorPoint }
    }

    override var size: CGSize {
        get { spriteNode.size }
        set(size) { spriteNode.size = size }
    }

    var color: UIColor {
        get { spriteNode.color }
        set(color) { spriteNode.color = color }
    }

    init(color: UIColor, size: CGSize) {
        super.init()
        node = SKSpriteNode(color: color, size: size)
        spriteNode.colorBlendFactor = 1.0
    }

    init(textures: TFTextures?, size: CGSize) {
        super.init()
        node = SKSpriteNode(texture: textures?.mainTexture, color: .white, size: size)
        spriteNode.colorBlendFactor = 0.3
    }

    init(imageName: String, size: CGSize) {
        super.init()
        node = SKSpriteNode(texture: SKTexture(imageNamed: imageName), color: .white, size: size)
        spriteNode.colorBlendFactor = 0.3
    }

    private var spriteNode: SKSpriteNode {
        guard let spriteNode = node as? SKSpriteNode else {
            fatalError("SKNode in TFNode was not a SKSpriteNode")
        }
        return spriteNode
    }
}
