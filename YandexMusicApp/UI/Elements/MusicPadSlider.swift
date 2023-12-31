//
//  Slider.swift
//  YandexMusicApp
//
//  Created by Евгений on 31.10.23.
//

import SwiftUI

struct MusicPadSlider: View {
	let text: LocalizedStringKey
	let isVertical: Bool

	private let width: CGFloat = Constants.sliderWidth
	private let height: CGFloat = 14

	init(_ text: LocalizedStringKey, isVertical: Bool = false) {
		self.text = text
		self.isVertical = isVertical
	}

	var horizontalSlider: some View {
		Text(text)
			.font(.ysTextSlider)
			.foregroundStyle(.black)
			.frame(width: width, height: height)
			.background(Colors.selection)
			.cornerRadius(Constants.sliderCornerRadius)
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
    MusicPadSlider("volume")
}
