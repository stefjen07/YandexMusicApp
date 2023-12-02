//
//  CGPoint+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import Foundation

extension CGPoint {
	static func +=(point1: inout CGPoint, point2: CGPoint) {
		point1 = .init(x: point1.x + point2.x, y: point1.y + point2.y)
	}

	static func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
		return .init(x: point.x * scalar, y: point.y * scalar)
	}

	func nearestPoint(xBounds: ClosedRange<CGFloat>, yBounds: ClosedRange<CGFloat>) -> CGPoint {
		return .init(x: xBounds.nearestValue(to: x), y: yBounds.nearestValue(to: y))
	}
}
