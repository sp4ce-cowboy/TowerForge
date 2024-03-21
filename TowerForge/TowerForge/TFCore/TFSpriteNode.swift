//
//  TFNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation
import SpriteKit
import CoreGraphics

class TFSpriteNode: SKSpriteNode {
    var textures: TFTextures?
    var width: CGFloat
    var height: CGFloat

    init(textures: TFTextures?, height: CGFloat, width: CGFloat) {
        if let textures = textures {
            self.textures = textures
        }
        self.width = width
        self.height = height
        super.init(texture: textures?.mainTexture, color: .clear, size: CGSize(width: width, height: height))
    }
    init(imageName: String, height: CGFloat, width: CGFloat) {
        self.width = width
        self.height = height
        super.init(texture: SKTexture(imageNamed: imageName), color: .clear, size: CGSize(width: width, height: height))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
