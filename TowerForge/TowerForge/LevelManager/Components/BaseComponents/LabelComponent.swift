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
    var label: SKLabelNode?
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
        label.position = CGPoint(x: 0, y: spriteComponent.node.height)
        label.name = "point"
        self.label = label
        spriteComponent.node.addChild(label)
    }
    func changeText(_ text: String) {
        guard let labelNode = label else {
            print("NO such thing")
            return
        }
        labelNode.text = text
    }
}
