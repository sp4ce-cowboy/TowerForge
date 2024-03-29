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
    func createAndAdd(node: TFNode, for entity: TFEntity) {
        guard entity.hasComponent(ofType: HealthComponent.self),
              let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }

        let healthNode = TFSpriteNode(color: HealthRenderStage.color, size: HealthRenderStage.size)
        healthNode.name = HealthRenderStage.name
        healthNode.position = CGPoint(x: -spriteComponent.size.width / 2,
                                      y: spriteComponent.size.height / 2 + HealthRenderStage.size.height + 10)
        healthNode.anchorPoint = CGPoint(x: 0, y: 0)
        node.add(child: healthNode)
    }

    func update(node: TFNode, for entity: TFEntity) {
        guard let healthNode = node.child(withName: HealthRenderStage.name),
              let healthComponent = entity.component(ofType: HealthComponent.self) else {
            return
        }
        let healthPercentage = healthComponent.currentHealth / healthComponent.maxHealth
        healthNode.xScale = healthPercentage
    }
}
