//
//  SpriteComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation

class SpriteComponent: TFComponent {
    var textures: TFTextures
    var size: CGSize
    var animatableKey: String
    var alpha = 1.0
    var staticOnScreen = false

    init(textureNames: [String], size: CGSize, animatableKey: String) {
        self.textures = TFTextures(textureNames: textureNames, textureAtlasName: "Sprites")
        self.size = size
        self.animatableKey = animatableKey
        super.init()
    }
}
