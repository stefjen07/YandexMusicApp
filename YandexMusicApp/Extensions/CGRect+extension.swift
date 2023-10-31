//
//  CGRect+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 31.10.23.
//

import Foundation

extension CGRect {
	func nearestPoint(to point: CGPoint) -> CGPoint {
		let x = (minX...maxX).nearestValue(to: point.x)
		let y = (minY...maxY).nearestValue(to: point.y)

		return .init(x: x, y: y)
	}

	var midPoint: CGPoint {
		.init(x: midX, y: midY)
	}
}
