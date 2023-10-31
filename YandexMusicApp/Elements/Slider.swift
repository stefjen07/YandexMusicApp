//
//  Slider.swift
//  YandexMusicApp
//
//  Created by Евгений on 31.10.23.
//

import SwiftUI

struct Slider: View {
	var text: String
	var isVertical: Bool

	private let width: CGFloat = 60
	private let height: CGFloat = 14

	init(_ text: String, isVertical: Bool = false) {
		self.text = text
		self.isVertical = isVertical
	}

	var horizontalSlider: some View {
		Text(text)
			.font(.ysTextSlider)
			.frame(width: width, height: height)
			.background(Colors.selection)
			.cornerRadius(4)
	}

	var body: some View {
		if isVertical {
			horizontalSlider
				.fixedSize()
				.rotationEffect(.degrees(-90))
				.frame(width: height, height: width)
		} else {
			horizontalSlider
		}
	}
}

#Preview {
    Slider("громкость")
}
