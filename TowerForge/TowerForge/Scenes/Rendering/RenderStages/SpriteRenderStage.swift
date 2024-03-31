//
//  SpriteRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import UIKit

class SpriteRenderStage: RenderStage {
    static let name = "sprite"
    func createAndAdd(node: TFNode, for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }

        let spriteNode = createAnimatableNode(with: spriteComponent)
        node.add(child: spriteNode)
        spriteNode.playAnimation()
    }

    func transform(node: TFNode, for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        node.staticOnScreen = spriteComponent.staticOnScreen
    }

    func update(node: TFNode, for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let spriteNode = node.child(withName: SpriteRenderStage.name) else {
            return
        }

        spriteNode.alpha = spriteComponent.alpha

        if node.staticOnScreen {
            node.position.x -= UIScreen.main.bounds.midX
            node.position.y -= UIScreen.main.bounds.midY
        }
    }

    private func createAnimatableNode(with spriteComponent: SpriteComponent) -> TFAnimatableNode {
        let textures = spriteComponent.textures
        let size = spriteComponent.size
        let animatableKey = spriteComponent.animatableKey
        let spriteNode = TFAnimatableNode(textures: textures, size: size, animatableKey: animatableKey)
        spriteNode.name = SpriteRenderStage.name

        return spriteNode
    }
}
