//
//  StatisticsEngine.swift
//  TowerForge
//
//  Created by Rubesh on 11/4/24.
//

import Foundation

protocol StatisticsUpdateDelegate: AnyObject {
    func onReceive(_ eventType: TFEventTypeWrapper)
}

class StatisticsEngine {
    var eventStatisticLinks = EventStatisticLinkDatabase()

    init(eventStatisticLinks: EventStatisticLinkDatabase = EventStatisticLinkDatabase()) {
        self.eventStatisticLinks = eventStatisticLinks
    }

    func onReceive(_ eventType: TFEventTypeWrapper) {
        guard let stats = eventStatisticLinks.getStatisticLinks(for: eventType) else {
            return
        }

        stats.forEach { $0.update(for: eventType) }
    }

    

}
