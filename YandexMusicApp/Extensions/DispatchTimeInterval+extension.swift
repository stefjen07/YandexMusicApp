//
//  DispatchTimeInterval+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 5.11.23.
//

import Foundation

extension DispatchTimeInterval {
	init(_ seconds: CGFloat) {
		self = .milliseconds(Int(seconds * 1000))
	}

	func toDouble() -> Double? {
			var result: Double? = 0

			switch self {
			case .seconds(let value):
				result = Double(value)
			case .milliseconds(let value):
				result = Double(value)*0.001
			case .microseconds(let value):
				result = Double(value)*0.000001
			case .nanoseconds(let value):
				result = Double(value)*0.000000001

			case .never:
				result = nil
			}

			return result
		}
}
