//
//  SpriteComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class SpriteComponent: TFComponent {
    var textures: TFTextures
    var height: CGFloat
    var width: CGFloat
    var animatableKey: String
    var node: TFAnimatableNode

    init(textureNames: [String], height: CGFloat, width: CGFloat, position: CGPoint, animatableKey: String) {
        textures = TFTextures(textureNames: textureNames, textureAtlasName: "Sprites")
        self.height = height
        self.width = width
        self.node = TFAnimatableNode(textures: textures, height: height, width: width, animatableKey: animatableKey)
        self.animatableKey = animatableKey
        super.init()
    }
}
