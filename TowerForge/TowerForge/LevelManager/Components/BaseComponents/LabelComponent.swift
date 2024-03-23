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
    func changeText(_ text: String) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self),
              let labelNode = spriteComponent.node.childNode(withName: "point") as? SKLabelNode else {
            return
        }
        labelNode.text = text
    }
}
