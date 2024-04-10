//
//  PositionRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class PositionRenderStage: RenderStage {
    private unowned let renderer: RenderTarget

    init(renderer: RenderTarget) {
        self.renderer = renderer
    }

    func render() {
        let entities = renderer.target.entities(with: PositionComponent.self)
        for entity in entities {
            update(for: entity)
        }
    }

    func update(for entity: TFEntity) {
        guard let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return
        }

        renderer.renderedNodes[entity.id]?.position = positionComponent.position
        renderer.flagNodeUpdated(with: entity.id)
    }

    func removeAndUncache(for id: UUID) {}
}
