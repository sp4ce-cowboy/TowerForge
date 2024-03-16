//
//  EventTarget.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

protocol EventTarget: AnyObject {
    func add(_ entity: TFEntity)
    func system<T: TFSystem>(ofType type: T.Type) -> T?
}
