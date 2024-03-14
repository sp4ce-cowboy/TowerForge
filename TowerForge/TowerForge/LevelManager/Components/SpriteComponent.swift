//
//  SpriteComponent.swift
//  TowerForge
//
//  Created by MacBook Pro on 14/03/24.
//

import Foundation

class SpriteComponent: TFComponent {
    public var node: TFAnimatableNode
    
    init(textureNames: [String], height: CGFloat, width: CGFloat, animatableKey: String) {
        let textures = TFTextures(textureNames: textureNames, textureAtlasName: "Sprites")
        self.node = TFAnimatableNode(textures: textures, height: height, width: width, animatableKey: animatableKey)
        super.init()
    }
}
