//
//  RenderStage.swift
//  TowerForge
//
//  Created by Zheng Ze on 29/3/24.
//

import Foundation

protocol RenderTarget: AnyObject {
    var target: Renderable { get }
    var renderedNodes: [UUID: TFNode] { get }
    func flagNodeUpdated(with id: UUID)
    func updateStaticNode(with id: UUID)
}

protocol RenderStage {
    func render()
    func create(for entity: TFEntity)
    func transform(for entity: TFEntity)
    func update(for entity: TFEntity)
    func removeAndUncache(for id: UUID)
}

extension RenderStage {
    func render() {}
    func create(for entity: TFEntity) {}
    func transform(for entity: TFEntity) {}
    func update(for entity: TFEntity) {}
    func removeAndUncache(for id: UUID) {}
}
