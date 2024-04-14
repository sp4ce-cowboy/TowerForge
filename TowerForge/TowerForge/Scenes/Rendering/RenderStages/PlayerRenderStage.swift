//
//  PlayerRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class PlayerRenderStage: RenderStage {
    private unowned let renderer: RenderTarget
    private var renderedNodes: Set<UUID> = []

    init(renderer: RenderTarget) {
        self.renderer = renderer
    }

    func render() {
        let entities = renderer.target.entities(with: PlayerComponent.self)
        for entity in entities where !renderedNodes.contains(entity.id) {
            transform(for: entity)
        }
    }

    func transform(for entity: TFEntity) {
        guard let playerComponent = entity.component(ofType: PlayerComponent.self) else {
            return
        }

        // prevent HUD labels from being scaled
        if entity.hasComponent(ofType: LabelComponent.self) {
            return
        }

        if playerComponent.player == .oppositePlayer {
            renderer.renderedNodes[entity.id]?.xScale *= -1
        }
        renderedNodes.insert(entity.id)
    }

    func removeAndUncache(for id: UUID) {
        renderedNodes.remove(id)
    }
}
