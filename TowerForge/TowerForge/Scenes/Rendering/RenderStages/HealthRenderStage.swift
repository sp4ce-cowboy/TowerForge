//
//  HealthRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import SpriteKit

class HealthRenderStage: RenderStage {
    static let name = "health"
    static let size = CGSize(width: 100, height: 10)
    static let color: UIColor = .green

    private unowned let renderer: RenderTarget
    private var renderedNodes: [UUID: TFSpriteNode] = [:]

    init(renderer: RenderTarget) {
        self.renderer = renderer
    }

    func render() {
        let entitiesToRender = renderer.target.entities(with: HealthComponent.self)

        for entity in entitiesToRender {
            if renderedNodes[entity.id] == nil {
                create(for: entity)
                continue
            }

            update(for: entity)
        }
    }

    func create(for entity: TFEntity) {
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self), entity.hasComponent(ofType: HealthComponent.self) else {
            return
        }
        let healthNode = TFSpriteNode(color: HealthRenderStage.color, size: HealthRenderStage.size)
        healthNode.name = HealthRenderStage.name
        healthNode.position = CGPoint(x: -spriteComponent.size.width / 2, y: spriteComponent.size.height / 2 + 5)
        healthNode.anchorPoint = CGPoint(x: 0, y: 0)
        renderedNodes[entity.id] = healthNode
        renderer.renderedNodes[entity.id]?.add(child: healthNode)
    }

    func update(for entity: TFEntity) {
        guard let healthComponent = entity.component(ofType: HealthComponent.self) else {
            return
        }
        let healthPercentage = healthComponent.currentHealth / healthComponent.maxHealth
        renderedNodes[entity.id]?.xScale = healthPercentage
        renderer.flagNodeUpdated(with: entity.id)
    }

    func removeAndUncache(for id: UUID) {
        renderedNodes.removeValue(forKey: id)
    }
}
