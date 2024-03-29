//
//  SpriteRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class SpriteRenderStage: RenderStage {
    static let name = "sprite"
    func transform(node: TFNode, for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }

        let spriteNode = createAnimatableNode(with: spriteComponent)
        node.add(child: spriteNode)
        spriteNode.playAnimation()
    }

    func update(node: TFNode, for entity: TFEntity) {
        guard  let spriteNode = node.child(withName: SpriteRenderStage.name),
               let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
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
