//
//  ButtonRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class ButtonRenderStage: RenderStage {
    static let name = "button"

    private unowned let renderer: RenderTarget
    private var renderedNodes: [UUID: TFButtonNode] = [:]

    init(renderer: RenderTarget) {
        self.renderer = renderer
    }

    func render() {
        let entitiesToRender = renderer.target.entities(with: ButtonComponent.self)

        for entity in entitiesToRender {
            if renderedNodes[entity.id] == nil {
                create(for: entity)
                continue
            }

            update(for: entity)
        }
    }

    func create(for entity: TFEntity) {
        guard let buttonComponent = entity.component(ofType: ButtonComponent.self) else {
            return
        }
        let buttonNode = TFButtonNode(action: buttonComponent.onTouch, size: buttonComponent.size)
        buttonNode.name = ButtonRenderStage.name
        buttonNode.zPosition = 1_000_000
        renderedNodes[entity.id] = buttonNode
        renderer.renderedNodes[entity.id]?.add(child: buttonNode)
    }

    func update(for entity: TFEntity) {
        guard let buttonComponent = entity.component(ofType: ButtonComponent.self) else {
            return
        }
        renderedNodes[entity.id]?.isUserInteractionEnabled = buttonComponent.userInteracterable
        renderer.flagNodeUpdated(with: entity.id)
    }

    func removeAndUncache(for id: UUID) {
        renderedNodes.removeValue(forKey: id)
    }
}
