//
//  CGVector+Extensions.swift
//  TowerForge
//
//  Created by Zheng Ze on 31/3/24.
//

import Foundation

extension CGVector {
    /**
     * Creates a new CGVector given a CGPoint.
     */
    public init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }

    /**
     * Returns the length (magnitude) of the vector described by the CGVector.
     */
    public func length() -> CGFloat {
        sqrt(dx * dx + dy * dy)
    }

    /**
     * Normalizes the vector described by the CGVector to length 1.0 and returns
     * the result as a new CGVector.
    public  */
    func normalized() -> CGVector {
        let len = length()
        return len > 0 ? self / len : CGVector.zero
    }

    /**
     * Normalizes the vector described by the CGVector to length 1.0.
     */
    public mutating func normalize() -> CGVector {
        self = normalized()
        return self
    }

    /**
     * Adds two CGVector values and returns the result as a new CGVector.
     */
    public static func + (left: CGVector, right: CGVector) -> CGVector {
        CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }

    /**
     * Increments a CGVector with the value of another.
     */
    public static func += (left: inout CGVector, right: CGVector) {
        left = left + right
    }

    /**
     * Subtracts two CGVector values and returns the result as a new CGVector.
     */
    public static func - (left: CGVector, right: CGVector) -> CGVector {
        CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }

    /**
     * Decrements a CGVector with the value of another.
     */
    public static func -= (left: inout CGVector, right: CGVector) {
        left = left - right
    }

    /**
     * Multiplies two CGVector values and returns the result as a new CGVector.
     */
    public static func * (left: CGVector, right: CGVector) -> CGVector {
        CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
    }

    /**
     * Multiplies a CGVector with another.
     */
    public static func *= (left: inout CGVector, right: CGVector) {
        left = left * right
    }

    /**
     * Multiplies the x and y fields of a CGVector with the same scalar value and
     * returns the result as a new CGVector.
     */
    public static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    /**
     * Multiplies the x and y fields of a CGVector with the same scalar value.
     */
    public static func *= (vector: inout CGVector, scalar: CGFloat) {
        vector = vector * scalar
    }

    /**
     * Divides two CGVector values and returns the result as a new CGVector.
     */
    public static func / (left: CGVector, right: CGVector) -> CGVector {
        CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
    }

    /**
     * Divides a CGVector by another.
     */
    public static func /= (left: inout CGVector, right: CGVector) {
        left = left / right
    }

    /**
     * Divides the dx and dy fields of a CGVector by the same scalar value and
     * returns the result as a new CGVector.
     */
    public static func / (vector: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
    }

    /**
     * Divides the dx and dy fields of a CGVector by the same scalar value.
     */
    public static func /= (vector: inout CGVector, scalar: CGFloat) {
        vector = vector / scalar
    }
}
