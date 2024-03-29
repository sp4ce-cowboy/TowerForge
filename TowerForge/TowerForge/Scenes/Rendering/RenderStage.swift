//
//  RenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

protocol RenderStage {
    func transform(node: TFNode, for entity: TFEntity)
    func update(node: TFNode, for entity: TFEntity)
}

extension RenderStage {
    func transform(node: TFNode, for entity: TFEntity) {}
    func update(node: TFNode, for entity: TFEntity) {}
}
