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

    init(textures: TFTextures, height: CGFloat, width: CGFloat, animatableKey: String) {
        self.animatableKey = animatableKey
        super.init(textures: textures, height: height, width: width)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func playAnimation() {
        guard animatableAction == nil, let textures = textures?.textures else {
            return
        }

        let animateAction = SKAction.animate(with: textures, timePerFrame: 0.1)
        let repeatableAction = SKAction.repeatForever(animateAction)
        run(repeatableAction, withKey: animatableKey)
        animatableAction = repeatableAction
    }

    func stopAnimation() {
        removeAction(forKey: animatableKey)
        animatableAction = nil
    }

}
