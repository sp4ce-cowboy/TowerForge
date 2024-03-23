//
//  LabelComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 23/03/24.
//

import Foundation
import SpriteKit

class LabelComponent: TFComponent {
    var text: String
    init(text: String) {
        self.text = text
        super.init()
    }
    override func didAddToEntity(_ entity: TFEntity) {
        self.entity = entity
        guard let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        let label = SKLabelNode(text: self.text)
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 60.0
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: spriteComponent.node.width, y: 0)
        label.name = "point"
        spriteComponent.node.addChild(label)
    }
    func changeText(_ text: String) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
              let labelNode = spriteComponent.node.childNode(withName: "point") as? SKLabelNode else {
            return
        }
        labelNode.text = text
    }
}
