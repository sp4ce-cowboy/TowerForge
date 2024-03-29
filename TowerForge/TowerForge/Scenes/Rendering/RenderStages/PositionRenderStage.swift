//
//  PositionRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class PositionRenderStage: RenderStage {
    func transform(node: TFNode, for entity: TFEntity) {
        guard let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return
        }
        node.position = positionComponent.position
    }

    func update(node: TFNode, for entity: TFEntity) {
        guard let positionComponent = entity.component(ofType: PositionComponent.self) else {
            return
        }

        node.position = positionComponent.position
    }
}
