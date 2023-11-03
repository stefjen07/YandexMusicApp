//
//  Font+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 31.10.23.
//

import SwiftUI

extension Font {
	init(_ name: String, size: CGFloat) {
		self.init(CTFont(name as CFString, size: size))
	}
}

// MARK: - Yandex Sans Text font
extension Font {
	static func ysText(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
		switch weight {
		default:
			return Font("YandexSansText-Regular", size: size)
		}
	}

	static let ysTextBody = ysText(14)
	static let ysTextSlider = ysText(12)
}
