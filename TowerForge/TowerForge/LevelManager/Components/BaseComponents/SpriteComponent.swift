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

    init(textureNames: [String], height: CGFloat, width: CGFloat, position: CGPoint, animatableKey: String) {
        textures = TFTextures(textureNames: textureNames, textureAtlasName: "Sprites")
        self.height = height
        self.width = width
        self.animatableKey = animatableKey
        super.init()
    }
}
