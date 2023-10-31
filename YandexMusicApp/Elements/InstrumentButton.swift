//
//  InstrumentButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct InstrumentButton: View {
	var instrument: InstrumentType

	@Binding var openedInstrument: InstrumentType?

	var isOpened: Bool {
		instrument == openedInstrument
	}

	func open() {
		openedInstrument = instrument
	}

	init(_ instrument: InstrumentType, openedInstrument: Binding<InstrumentType?>) {
		self.instrument = instrument
		self._openedInstrument = openedInstrument
	}

	var body: some View {
		ZStack(alignment: .top) {
			VStack {
				instrument.icon
					.frame(width: 60, height: 60)
					.background(Color.white)
					.clipShape(Circle())

				Text(instrument.name)
					.font(.ysTextBody)
					.foregroundStyle(.white)
			}
			.onLongPressGesture {
				open()
			}

			if isOpened {
				VStack(spacing: 0) {
					instrument.icon
					
					ForEach(1..<4) { i in
						Text("сэмпл \(i)")
							.font(.ysTextBody)
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
				.frame(width: 60)
				.background(Colors.selection)
				.clipShape(Capsule())
			}
		}
	}
}

#Preview {
	InstrumentButton(.guitar, openedInstrument: .constant(nil))
}
