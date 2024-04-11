//
//  LabelRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class LabelRenderStage: RenderStage {
    static let name = "label"

    private unowned let renderer: RenderTarget
    private var renderedNodes: [UUID: TFLabelNode] = [:]

    init(renderer: RenderTarget) {
        self.renderer = renderer
    }

    func render() {
        let entitiesToRender = renderer.target.entities(with: LabelComponent.self)

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
        guard let labelComponent = entity.component(ofType: LabelComponent.self) else {
            return
        }
        let labelNode = createLabelNode(with: labelComponent)
        renderedNodes[entity.id] = labelNode
        renderer.renderedNodes[entity.id]?.add(child: labelNode)

        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            labelNode.position = CGPoint(x: spriteComponent.size.width, y: 0)
            labelNode.position.x += labelComponent.displacement.dx
            labelNode.position.y += labelComponent.displacement.dy
        }
    }

    func update(for entity: TFEntity) {
        guard let labelComponent = entity.component(ofType: LabelComponent.self) else {
            return
        }
        renderedNodes[entity.id]?.text = labelComponent.title
        renderer.flagNodeUpdated(with: entity.id)
    }

    func removeAndUncache(for id: UUID) {
        renderedNodes.removeValue(forKey: id)
    }

    private func createLabelNode(with labelComponent: LabelComponent) -> TFLabelNode {
        let labelNode = TFLabelNode(text: labelComponent.title)
        labelNode.fontColor = labelComponent.fontColor
        labelNode.fontName = labelComponent.fontName
        labelNode.fontSize = labelComponent.fontSize
        labelNode.horizontalAlignmentMode = labelComponent.horizontalAlignment
        labelNode.verticalAlignmentMode = labelComponent.verticalAlignment
        labelNode.name = LabelRenderStage.name

        if let subtitle = labelComponent.subtitle {
            let subtitleNode = TFLabelNode(text: subtitle)
            subtitleNode.fontColor = labelComponent.fontColor
            subtitleNode.fontName = labelComponent.fontName
            subtitleNode.fontSize = labelComponent.fontSize * 0.2
            subtitleNode.horizontalAlignmentMode = labelComponent.horizontalAlignment
            subtitleNode.verticalAlignmentMode = labelComponent.verticalAlignment
            subtitleNode.position = PositionConstants.SUBTITLE_LABEL_OFFSET
            subtitleNode.name = "\(LabelRenderStage.name)-subtitle"
            labelNode.add(child: subtitleNode)
        }

        return labelNode
    }
}
