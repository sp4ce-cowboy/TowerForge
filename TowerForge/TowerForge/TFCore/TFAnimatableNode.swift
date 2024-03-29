//
//  TFAnimatableNode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 14/03/24.
//

import Foundation
import SpriteKit

class TFAnimatableNode: TFSpriteNode, Animatable {
    var animatableAction: SKAction?
    var animatableKey: String
    var textures: TFTextures

    init(textures: TFTextures, size: CGSize, animatableKey: String) {
        self.animatableKey = animatableKey
        super.init(textures: textures, size: size)
    }

    func playAnimation() {
        guard animatableAction == nil else {
            return
        }

        let animateAction = SKAction.animate(with: textures.textures, timePerFrame: 0.1)
        let repeatableAction = SKAction.repeatForever(animateAction)
        node.run(repeatableAction, withKey: animatableKey)
        animatableAction = repeatableAction
    }

    func stopAnimation() {
        node.removeAction(forKey: animatableKey)
        animatableAction = nil
    }
}
