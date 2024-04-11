//
//  TFRenderer.swift
//  TowerForge
//
//  Created by Zheng Ze on 21/3/24.
//

import Foundation
import SpriteKit

class TFRenderer {
    unowned var target: Renderable
    var renderedNodes: [UUID: TFNode] = [:]

    private unowned var scene: TFScene?
    private var renderStages: [RenderStage] = []
    private var nodesToBeRemoved: Set<UUID> = []

    init(target: Renderable, scene: GameScene?) {
        self.target = target
        self.scene = scene

        setupRenderStages()
    }

    private func setupRenderStages() {
        renderStages.append(PositionRenderStage(renderer: self))
        renderStages.append(SpriteRenderStage(renderer: self))
        renderStages.append(LabelRenderStage(renderer: self))
        renderStages.append(HealthRenderStage(renderer: self))
        renderStages.append(ButtonRenderStage(renderer: self))
        renderStages.append(PlayerRenderStage(renderer: self))
    }

    private func removeAndUncache(with id: UUID) {
        guard let node = renderedNodes.removeValue(forKey: id) else {
            return
        }

        for renderStage in renderStages {
            renderStage.removeAndUncache(for: id)
        }

        node.removeFromParent()
    }
}

extension TFRenderer: Renderer {
    func render() {
        nodesToBeRemoved.removeAll(keepingCapacity: true)
        nodesToBeRemoved = Set(renderedNodes.keys)
        createNodeForEntities()

        for renderStage in renderStages {
            renderStage.render()
        }

        for entityId in nodesToBeRemoved {
            removeAndUncache(with: entityId)
        }
    }

    func renderMessage(_ message: String) {
        guard let scene = self.scene else {
            return
        }
        let labelNode = TFLabelNode(text: message)
        labelNode.name = "message"
        labelNode.fontSize = 50.0
        labelNode.fontName = "Nosifer-Regular"
        labelNode.position = CGPoint(x: 0, y: 0)
        labelNode.zPosition = 1_000

        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        let waitAction = SKAction.wait(forDuration: 1.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeInAction, waitAction, fadeOutAction, removeAction])

        labelNode.run(sequence)
        scene.add(node: labelNode, staticOnScreen: true)
    }

    private func createNodeForEntities() {
        for entity in target.entitiesToRender where renderedNodes[entity.id] == nil {
            let node = TFNode()
            node.name = entity.id.uuidString
            renderedNodes[entity.id] = node
            scene?.add(node: node, staticOnScreen: node.staticOnScreen)
        }
    }
}

extension TFRenderer: RenderTarget {
    func flagNodeUpdated(with id: UUID) {
        nodesToBeRemoved.remove(id)
    }

    func updateStaticNode(with id: UUID) {
        if let node = renderedNodes[id] {
            scene?.setNode(node, isStatic: node.staticOnScreen)
        }
    }
}
