//
//  LabelRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class LabelRenderStage: RenderStage {
    static let name = "label"
    func createAndAdd(node: TFNode, for entity: TFEntity) {
        guard let labelComponent = entity.component(ofType: LabelComponent.self) else {
            return
        }
        let labelNode = createLabelNode(with: labelComponent)
        node.add(child: labelNode)

        if let spriteComponent = entity.component(ofType: SpriteComponent.self) {
            labelNode.position = CGPoint(x: spriteComponent.size.width, y: 0)
            labelNode.position.x += labelComponent.displacement.dx
            labelNode.position.y += labelComponent.displacement.dy
        }
    }

    func update(node: TFNode, for entity: TFEntity) {
        guard let labelNode = node.child(withName: LabelRenderStage.name) as? TFLabelNode,
              let labelComponent = entity.component(ofType: LabelComponent.self) else {
            return
        }
        labelNode.text = labelComponent.title
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
            subtitleNode.fontSize = labelComponent.fontSize * 0.5
            subtitleNode.horizontalAlignmentMode = labelComponent.horizontalAlignment
            subtitleNode.verticalAlignmentMode = labelComponent.verticalAlignment
            subtitleNode.position = CGPoint(x: 0, y: -20)
            labelNode.add(child: subtitleNode)
        }

        return labelNode
    }
}
