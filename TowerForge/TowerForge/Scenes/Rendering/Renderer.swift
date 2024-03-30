//
//  Renderer.swift
//  TowerForge
//
//  Created by Zheng Ze on 21/3/24.
//

import Foundation
import SpriteKit

class Renderer {
    private unowned var target: Renderable
    private unowned var scene: SKScene?

    private var renderedNodes: [UUID: TFNode] = [:]
    private var renderStages: [RenderStage] = []

    init(target: Renderable, scene: GameScene?) {
        self.target = target
        self.scene = scene

        setupRenderStages()
    }

    func render() {
        var nodesToBeRemoved = renderedNodes

        for entity in target.entitiesToRender {
            guard nodesToBeRemoved[entity.id] != nil else {
                addAndCache(entity: entity)
                continue
            }

            nodesToBeRemoved.removeValue(forKey: entity.id)
            update(entity: entity)
        }

        for entityId in nodesToBeRemoved.keys {
            removeAndUncache(with: entityId)
        }
    }

    func renderMessage(_ message: String) {
        guard let scene = self.scene else {
            return
        }
        let label = SKLabelNode(text: message)
        label.name = "message"
        label.fontSize = 50.0
        label.fontName = "Nosifer-Regular"
        label.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        scene.addChild(label)

        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        let waitAction = SKAction.wait(forDuration: 1.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction, removeAction])
        label.run(sequence)
    }

    private func setupRenderStages() {
        renderStages.append(SpriteRenderStage())
        renderStages.append(LabelRenderStage())
        renderStages.append(PositionRenderStage())
        renderStages.append(HealthRenderStage())
        renderStages.append(PlayerRenderStage())
        renderStages.append(ButtonRenderStage())
    }

    private func update(entity: TFEntity) {
        guard let node = renderedNodes[entity.id] else {
            return
        }

        for renderStage in renderStages {
            renderStage.update(node: node, for: entity)
        }
    }

    private func addAndCache(entity: TFEntity) {
        let node = TFNode()
        node.name = entity.id.uuidString

        for renderStage in renderStages {
            renderStage.createAndAdd(node: node, for: entity)
        }

        for renderStage in renderStages {
            renderStage.transform(node: node, for: entity)
        }

        renderedNodes[entity.id] = node
        scene?.addChild(node.node)
    }

    private func removeAndUncache(with id: UUID) {
        guard let node = renderedNodes.removeValue(forKey: id) else {
            return
        }
        node.removeFromParent()
    }
}
