//
//  TFNetworkCoder.swift
//  TowerForge
//
//  Created by Zheng Ze on 4/4/24.
//

import Foundation

class TFNetworkCoder {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
    static func toJsonString(event: TFRemoteEvent) -> String {
        do {
            if let jsonString = String(data: try encoder.encode(event), encoding: .utf8) {
                return jsonString
            }
        } catch {}
        fatalError("Unable to encode TFRemoteEvent to JSON")
    }

    static func fromJsonString(_ string: String) -> TFRemoteEvent? {
        do {
            let jsonData = Data(string.utf8)
            let baseEvent = try decoder.decode(BaseRemoteEvent.self, from: jsonData)

            guard let type = Bundle.main.classNamed("TowerForge.\(baseEvent.type)") as? TFRemoteEvent.Type else {
                return nil
            }
            return try decoder.decode(type.self, from: jsonData)
        } catch {
            fatalError("Unable to decode TFRemoteEvent from JSON")
        }
    }
}
