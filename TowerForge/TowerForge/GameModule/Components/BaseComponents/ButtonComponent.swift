//
//  ButtonComponent.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

class ButtonComponent: TFComponent {
    var size: CGSize
    var onTouch: TFButtonDelegate?
    var userInteracterable = true

    init(size: CGSize, buttonDelegate: TFButtonDelegate? = nil) {
        self.size = size
        self.onTouch = buttonDelegate
    }
}
