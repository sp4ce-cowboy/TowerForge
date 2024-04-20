//
//  SpriteComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import UIKit

class SpriteComponent: TFComponent {
    var textures: TFTextures
    var size: CGSize
    var animatableKey: String
    var alpha = 1.0
    var staticOnScreen = false
    var zPosition: CGFloat
    var tint: UIColor = .white

    init(textureNames: [String], size: CGSize, animatableKey: String, zPosition: CGFloat = .zero) {
        self.textures = TFTextures(textureNames: textureNames, textureAtlasName: "Sprites")
        self.size = size
        self.animatableKey = animatableKey
        self.zPosition = zPosition
        super.init()
    }
}
