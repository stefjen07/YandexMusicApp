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
		withAnimation(.easeIn) {
			openedInstrument = instrument
		}
	}

	func close() {
		withAnimation(.easeOut) {
			openedInstrument = nil
		}
	}

	init(_ instrument: InstrumentType, openedInstrument: Binding<InstrumentType?>) {
		self.instrument = instrument
		self._openedInstrument = openedInstrument
	}

	var body: some View {
		VStack(spacing: 10) {
			instrument.icon
				.resizable()
				.frame(height: Constants.instrumentButtonSize)
				.background(isOpened ? .clear : Colors.buttonBackground)
				.clipShape(Circle())

			if isOpened {
				VStack(spacing: 0) {
					ForEach(1..<4) { i in
						Text("sample \(i)")
							.font(.ysTextBody)
							.foregroundStyle(.black)
							.padding(.horizontal, 6)
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
									endPoint: .bottom
								)
							)
					}
				}
				.padding(.bottom, 30)
			} else {
				Text(instrument.name)
					.font(.ysTextBody)
					.foregroundStyle(.primary)
			}
		}
		.frame(width: Constants.instrumentButtonSize)
		.background {
			if isOpened {
				Colors.selection
					.clipShape(Capsule())
			}
		}
		.onLongPressGesture {
			if isOpened {
				close()
			} else {
				open()
			}
		}
	}
}

struct InstrumentButtonPreview: View {
	@State var openedInstrument: InstrumentType?

	var body: some View {
		InstrumentButton(.guitar, openedInstrument: $openedInstrument)
	}
}

#Preview {
	VStack {
		InstrumentButtonPreview()
		Spacer()
	}
		.padding()
}
