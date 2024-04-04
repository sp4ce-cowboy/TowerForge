//
//  TFRemoteEventPublisher.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation

protocol TFRemoteEventPublisher {
    func publish(remoteEvent: TFRemoteEvent)
}
