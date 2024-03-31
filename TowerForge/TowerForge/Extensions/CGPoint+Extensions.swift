//
//  CGPoint+Extensions.swift
//  TowerForge
//
//  Created by Zheng Ze on 31/3/24.
//

import Foundation

extension CGPoint {
    init(x: Float, y: Float) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }

    func distanceTo(_ point: CGPoint) -> CGFloat {
        (self - point).length()
    }

    func length() -> CGFloat {
        sqrt(self.x * self.x + self.y * self.y)
    }

    /**
     * Adds two CGPoint values and returns the result as a new CGPoint.
     */
    public static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    /**
     * Increments a CGPoint with the value of another.
     */
    public static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }

    /**
     * Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
     */
    public static func + (left: CGPoint, right: CGVector) -> CGPoint {
        CGPoint(x: left.x + right.dx, y: left.y + right.dy)
    }

    /**
     * Increments a CGPoint with the value of a CGVector.
     */
    public static func += (left: inout CGPoint, right: CGVector) {
        left = left + right
    }

    /**
     * Subtracts two CGPoint values and returns the result as a new CGPoint.
     */
    public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    /**
     * Decrements a CGPoint with the value of another.
     */
    public static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }

    /**
     * Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
     */
    public static func - (left: CGPoint, right: CGVector) -> CGPoint {
        CGPoint(x: left.x - right.dx, y: left.y - right.dy)
    }

    /**
     * Decrements a CGPoint with the value of a CGVector.
     */
    public static func -= (left: inout CGPoint, right: CGVector) {
        left = left - right
    }

    /**
     * Multiplies two CGPoint values and returns the result as a new CGPoint.
     */
    public static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x * right.x, y: left.y * right.y)
    }

    /**
     * Multiplies a CGPoint with another.
     */
    public static func *= (left: inout CGPoint, right: CGPoint) {
        left = left * right
    }

    /**
     * Multiplies the x and y fields of a CGPoint with the same scalar value and
     * returns the result as a new CGPoint.
     */
    public static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /**
     * Multiplies the x and y fields of a CGPoint with the same scalar value.
     */
    public static func *= (point: inout CGPoint, scalar: CGFloat) {
        point = point * scalar
    }

    /**
     * Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
     */
    public static func * (left: CGPoint, right: CGVector) -> CGPoint {
        CGPoint(x: left.x * right.dx, y: left.y * right.dy)
    }

    /**
     * Multiplies a CGPoint with a CGVector.
     */
    public static func *= (left: inout CGPoint, right: CGVector) {
        left = left * right
    }

    /**
     * Divides two CGPoint values and returns the result as a new CGPoint.
     */
    public static func / (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x / right.x, y: left.y / right.y)
    }

    /**
     * Divides a CGPoint by another.
     */
    public static func /= (left: inout CGPoint, right: CGPoint) {
        left = left / right
    }

    /**
     * Divides the x and y fields of a CGPoint by the same scalar value and returns
     * the result as a new CGPoint.
     */
    public static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x / scalar, y: point.y / scalar)
    }

    /**
     * Divides the x and y fields of a CGPoint by the same scalar value.
     */
    public static func /= (point: inout CGPoint, scalar: CGFloat) {
        point = point / scalar
    }

    /**
     * Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
     */
    public static func / (left: CGPoint, right: CGVector) -> CGPoint {
        CGPoint(x: left.x / right.dx, y: left.y / right.dy)
    }

    /**
     * Divides a CGPoint by a CGVector.
     */
    public static func /= (left: inout CGPoint, right: CGVector) {
        left = left / right
    }
}
