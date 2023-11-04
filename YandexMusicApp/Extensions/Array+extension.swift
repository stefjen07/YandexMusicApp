//
//  Array+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 4.11.23.
//

import Foundation

extension Array {
	func suffix(_ length: Int, filler: Element) -> [Element] {
		return Array(repeating: filler, count: Swift.max(0, length - count)) + suffix(length)
	}

	func suffixWithIndices(_ length: Int, filler: Element) -> [(value: Element, index: Int)] {
		return zip(suffix(length, filler: filler), stride(from: count - length, to: count - 1, by: 1)).map { ($0, $1) }
	}
}
