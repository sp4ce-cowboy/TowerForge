//
//  LabelComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 23/03/24.
//

import SpriteKit

class LabelComponent: TFComponent {
    var title: String
    var subtitle: String?
    var name: String
    var fontColor: UIColor = .white
    var fontName: String = "HelveticaNeue-Bold"
    var fontSize: CGFloat = 60
    var zPosition: CGFloat = 0
    var displacement: CGVector = .zero
    var horizontalAlignment: AlignmentMode = .center
    var verticalAlignment: AlignmentMode = .center

    init(text: String, name: String, subtitle: String? = nil) {
        self.title = text
        self.subtitle = subtitle
        self.name = name
        super.init()
    }

    func changeText(_ text: String) {
        self.title = text
    }
}
