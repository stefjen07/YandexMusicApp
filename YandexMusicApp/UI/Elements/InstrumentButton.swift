//
//  InstrumentButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct InstrumentButton: View {
	let instrument: InstrumentType

	let sampleManager: SampleManagerProtocol
	@ObservedObject var trackManager: TrackManager
	@Binding var openedInstrument: InstrumentType?

	@State private var highlightedSample: Int?
	@State private var recentSample: Int?
	@State private var isTapped = false
	@State private var sampleFrames: [Int: CGRect] = [:]

	var isOpened: Bool {
		instrument == openedInstrument
	}

	var isDisabled: Bool {
		trackManager.isFullPlaying || trackManager.isFullRecording
	}

	func open() {
		withAnimation(.easeIn) {
			openedInstrument = instrument
		}
	}

	func selectSample(_ index: Int) {
		recentSample = index
		
		trackManager.createInstrumentTrack(instrument, sample: index)
	}

	func close() {
		highlightedSample = nil
		withAnimation(.easeOut) {
			openedInstrument = nil
		}
	}

	init(_ instrument: InstrumentType, 
		 openedInstrument: Binding<InstrumentType?>,
		 sampleManager: SampleManagerProtocol,
		 trackManager: TrackManager
	) {
		self.instrument = instrument
		self.sampleManager = sampleManager
		self.trackManager = trackManager
		self._openedInstrument = openedInstrument
	}

	var body: some View {
		VStack(spacing: 10) {
			instrument.icon
				.resizable()
				.frame(height: Constants.instrumentButtonSize)
				.background { () -> Color in
					if isDisabled {
						return Colors.disabledBackground
					}

					if isOpened {
						return .clear
					}

					return isTapped ? Colors.selection : Colors.buttonBackground
				}
				.clipShape(Circle())

			if isOpened {
				VStack(spacing: 0) {
					ForEach(sampleManager.getSamplesIndices(instrument), id: \.self) { i in
						HStack(spacing: 0) {
							Spacer(minLength: 0)
							Text("sample \(i+1)")
								.font(.ysTextBody)
								.foregroundStyle(.black)
							Spacer(minLength: 0)
						}
							.padding(.horizontal, 6)
							.padding(.vertical, 12)
							.background {
								if highlightedSample == i {
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
								}

								GeometryReader { proxy -> Color in
									DispatchQueue.main.async {
										sampleFrames[i] = proxy.frame(in: .global)
									}

									return Color.clear
								}
							}
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
		.gesture(
			SimultaneousGesture(
				SimultaneousGesture(
					LongPressGesture()
						.onEnded { _ in
							open()
						},
					TapGesture()
						.onEnded { _ in
							withAnimation {
								openedInstrument = nil
								isTapped = true
							}

							let sample = recentSample ?? 0
							withAnimation {
								highlightedSample = sample
								openedInstrument = instrument
							}
							selectSample(sample)
							sampleManager.playSamplePreview(instrument, sample: sample, duration: 5)

							Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
								withAnimation {
									highlightedSample = nil
									openedInstrument = nil
									isTapped = false
								}
							}
						}
				),
				DragGesture(minimumDistance: 0, coordinateSpace: .global)
					.onChanged { value in
						if openedInstrument == instrument {
							for i in sampleManager.getSamplesIndices(instrument) {
								if let frame = sampleFrames[i],
								   frame.contains(value.location) {
									if highlightedSample != i {
										highlightedSample = i
										sampleManager.playSamplePreview(instrument, sample: i)
									}

									return
								}
							}

							highlightedSample = nil
							sampleManager.stopSamplePreview()
						}
					}
					.onEnded { _ in
						if openedInstrument == instrument && !isTapped {
							if let highlightedSample {
								selectSample(highlightedSample)
							}
							sampleManager.stopSamplePreview()

							close()
						}
					}
			)
		)
		.disabled(isDisabled)
	}
}

struct InstrumentButtonPreview: View {
	@State private var openedInstrument: InstrumentType?

	var body: some View {
		InstrumentButton(
			.guitar,
			openedInstrument: $openedInstrument,
			sampleManager: SampleManager(),
			trackManager: .init(sampleManager: SampleManager())
		)
	}
}

#Preview {
	VStack {
		InstrumentButtonPreview()
		Spacer()
	}
		.padding()
}
