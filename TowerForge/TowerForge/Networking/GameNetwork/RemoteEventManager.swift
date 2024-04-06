//
//  RemoteEventManager.swift
//  TowerForge
//
//  Created by Zheng Ze on 5/4/24.
//

import Foundation

class RemoteEventManager {
    let publisher: TFRemoteEventPublisher
    let subscriber: TFRemoteEventSubscriber

    init(publisher: TFRemoteEventPublisher, subscriber: TFRemoteEventSubscriber) {
        self.publisher = publisher
        self.subscriber = subscriber
    }
}
