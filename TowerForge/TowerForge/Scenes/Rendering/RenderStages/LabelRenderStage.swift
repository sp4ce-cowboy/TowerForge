//
//  LabelRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class LabelRenderStage: RenderStage {
    static let name = "label"
    func transform(node: TFNode, for entity: TFEntity) {
        guard let labelComponent = entity.component(ofType: LabelComponent.self) else {
            return
        }
        let labelNode = createLabelNode(with: labelComponent)
        node.add(child: labelNode)
    }

    func update(node: TFNode, for entity: TFEntity) {
        guard let labelNode = node.child(withName: LabelRenderStage.name) as? TFLabelNode,
              let labelComponent = entity.component(ofType: LabelComponent.self) else {
            return
        }
        labelNode.text = labelComponent.text
    }

    private func createLabelNode(with labelComponent: LabelComponent) -> TFLabelNode {
        let labelNode = TFLabelNode(text: labelComponent.text)
        labelNode.fontColor = labelComponent.fontColor
        labelNode.fontName = labelComponent.fontName
        labelNode.fontSize = labelComponent.fontSize
        labelNode.horizontalAlignementMode = labelComponent.horizontalAlignment
        labelNode.verticalAlignementMode = labelComponent.verticalAlignment

        return labelNode
    }
}
