//
//  InstrumentButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct InstrumentButton: View {
	var instrument: InstrumentType

	init(_ instrument: InstrumentType) {
		self.instrument = instrument
	}

	var body: some View {
		ZStack(alignment: .top) {
			VStack {
				instrument.icon
					.background(Color.white)
					.clipShape(Circle())

				Text(instrument.name)
					.foregroundStyle(.white)
			}

			VStack(spacing: 0) {
				instrument.icon

				ForEach(1..<4) { i in
					Text("сэмпл \(i)")
						.padding(.horizontal, 8)
						.padding(.vertical, 12)
						.background(
							LinearGradient(
								colors: [
									.white.opacity(0),
									.white.opacity(0.75),
									.white,
									.white.opacity(0.75),
									.white.opacity(0)
								],
								startPoint: .top,
								endPoint: .bottom)
						)
				}
			}
			.padding(.bottom, 30)
			.background(Colors.selection)
			.clipShape(Capsule())
		}
	}
}

#Preview {
	InstrumentButton(.guitar)
}
