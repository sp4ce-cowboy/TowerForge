//
//  ButtonRenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class ButtonRenderStage: RenderStage {
    static let name = "button"
    func createAndAdd(node: TFNode, for entity: TFEntity) {
        guard let buttonComponent = entity.component(ofType: ButtonComponent.self) else {
            return
        }
        let buttonNode = TFButtonNode(action: buttonComponent.onTouch, size: buttonComponent.size)
        buttonNode.name = ButtonRenderStage.name
        buttonNode.zPosition = 1_000
        node.add(child: buttonNode)
    }

    func update(node: TFNode, for entity: TFEntity) {
        guard let buttonComponent = entity.component(ofType: ButtonComponent.self),
              let buttonNode = node.child(withName: ButtonRenderStage.name) else {
            return
        }
        buttonNode.isUserInteractionEnabled = buttonComponent.userInteracterable
    }
}
