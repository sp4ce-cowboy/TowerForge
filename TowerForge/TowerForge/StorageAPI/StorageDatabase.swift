//
//  Storage.swift
//  TowerForge
//
//  Created by Rubesh on 18/4/24.
//

import Foundation

protocol StorageDatabase: Codable, AnyObject {
    func encode(to encoder: Encoder) throws
    init(from decoder: Decoder) throws
}
