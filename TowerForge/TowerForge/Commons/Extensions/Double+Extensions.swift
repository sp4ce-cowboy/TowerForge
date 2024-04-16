//
//  Double+Extensions.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

extension Double {
    static var unit: Double { 1.0 }
    var half: Double { self * 0.5 }
    var twice: Double { self * 2.0 }
    var oneHalf: Double { self * 1.5 }
    var square: Double { pow(self, 2) }
    var sqroot: Double { sqrt(self) }
    func divide(by value: Double) -> Double { self / value }
}

extension Int {
    static var unit: Int { 1 }
    static var zero: Int { 0 }
    static var negativeUnit: Int { -1 }
}

extension CGFloat {
    static var unit: Double { Double.unit }
    var half: Double { Double(self).half }
    var twice: Double { Double(self).twice }
    var square: Double { Double(self).square }
    var sqroot: Double { Double(self).sqroot }
}

extension CGPoint {
    var half: CGPoint {
        CGPoint(x: self.x / 2.0, y: self.y / 2.0)
    }
}

extension Bundle {
    /// A convenience extension to safely retrieve the bundle name
    var projectName: String {
        object(forInfoDictionaryKey: "CFBundleName") as? String ?? Constants.PROJECT_NAME_PREFIX
    }
}

extension String {
    /// The NSClass name of a given class within the TowerForge Module represented in its full
    /// form
    var asTFClassFromString: AnyClass? {
        NSClassFromString(Bundle.main.projectName + "." + self)
    }
}
