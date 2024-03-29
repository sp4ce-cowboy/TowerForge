//
//  RenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

protocol RenderStage {
    func createAndAdd(node: TFNode, for entity: TFEntity)
    func transform(node: TFNode, for entity: TFEntity)
    func update(node: TFNode, for entity: TFEntity)
}

extension RenderStage {
    func createAndAdd(node: TFNode, for entity: TFEntity) {}
    func transform(node: TFNode, for entity: TFEntity) {}
    func update(node: TFNode, for entity: TFEntity) {}
}
