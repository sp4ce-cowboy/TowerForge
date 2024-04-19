//
//  SpriteRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import UIKit

class SpriteRenderStage: RenderStage {
    static var offset = CGFloat.zero
    static let name = "sprite"
    static let opponentTint: UIColor = .red
    private unowned let renderer: RenderTarget
    private var renderedNodes: [UUID: TFAnimatableNode] = [:]

    init(renderer: RenderTarget) {
        self.renderer = renderer
    }

    func render() {
        let entitiesToRender = renderer.target.entities(with: SpriteComponent.self)

        for entity in entitiesToRender {
            if renderedNodes[entity.id] == nil {
                create(for: entity)
                transform(for: entity)
                continue
            }

            update(for: entity)
        }
    }

    func create(for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        let spriteNode = createAnimatableNode(with: spriteComponent)
        renderedNodes[entity.id] = spriteNode
        spriteNode.playAnimation()
        renderer.renderedNodes[entity.id]?.add(child: spriteNode)
    }

    func transform(for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        renderer.renderedNodes[entity.id]?.staticOnScreen = spriteComponent.staticOnScreen
        renderer.renderedNodes[entity.id]?.zPosition = spriteComponent.zPosition + SpriteRenderStage.offset
        SpriteRenderStage.offset += 0.00001
        renderer.updateStaticNode(with: entity.id)
    }

    func update(for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self),
              let spriteNode = renderedNodes[entity.id] else {
            return
        }
        spriteNode.alpha = spriteComponent.alpha

        if let node = renderer.renderedNodes[entity.id], node.staticOnScreen {
            node.position.x -= UIScreen.main.bounds.midX
            node.position.y -= UIScreen.main.bounds.midY
        }

        renderer.flagNodeUpdated(with: entity.id)
    }

    func removeAndUncache(for id: UUID) {
        renderedNodes.removeValue(forKey: id)
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
