//
//  StatisticsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

protocol StatisticsUpdateDelegate {
    func receiveNotification(_ eventType: TFEventTypeWrapper)
}

class StatisticsEngine: StatisticsUpdateDelegate {
    var eventStatisticLinks = EventStatisticLinkDatabase()
    
    func receiveNotification(_ eventType: TFEventTypeWrapper) {
        guard let stats = eventStatisticLinks
                                .getStatisticLinks(for: eventType) else {
            return
        }
        
        for stat in stats {
            stat.update(for: eventType)
        }
    }
}
