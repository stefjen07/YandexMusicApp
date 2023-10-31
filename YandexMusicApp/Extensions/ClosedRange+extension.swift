//
//  ClosedRange+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 31.10.23.
//

import Foundation

extension ClosedRange {
	func nearestValue(to value: Bound) -> Bound {
		if value < lowerBound {
			return lowerBound
		} else if value > upperBound {
			return upperBound
		} else {
			return value
		}
	}
}
