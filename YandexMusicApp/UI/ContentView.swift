//
//  ContentView.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct ContentView: View {
	let sampleManager: SampleManager = .init()
	@ObservedObject var trackManager: TrackManager = .init()
	@ObservedObject var voiceRecorder: VoiceRecorder = .init()

	@State private var isDropdownMenuOpened = false
	@State private var isMicrophoneAlertPresented = false
	@State private var urlToShare: URL?
	@State private var openedInstrument: InstrumentType?

	var body: some View {
		VStack(spacing: 21) {
			GeometryReader { proxy in
				ZStack(alignment: .top) {
					HStack(alignment: .top) {
						ForEach(InstrumentType.allCases) { instrument in
							InstrumentButton(
								instrument,
								openedInstrument: $openedInstrument,
								sampleManager: sampleManager,
								trackManager: trackManager
							)

							if instrument != InstrumentType.allCases.last {
								Spacer()
							}
						}
					}
					.zIndex(1000)

					MusicPad(volume: trackManager.volume, speed: trackManager.speed)
						.padding(.top, 120)

					VStack(spacing: 7) {
						Spacer()

						if isDropdownMenuOpened {
							TracksView(trackManager: trackManager, isPresented: $isDropdownMenuOpened)
							.frame(maxHeight: proxy.size.height * 0.8, alignment: .bottom)
							.fixedSize(horizontal: false, vertical: true)
						}
					}
					.offset(y: Constants.audioWaveHeight + 21)
					.zIndex(1000)
				}
			}
			.zIndex(1000)

			AudioWaveView(trackManager: trackManager)

			HStack {
				DropdownMenuButton("layers", isOpened: $isDropdownMenuOpened)

				Spacer()

				SquareButton(Icons.microphone) {
					if voiceRecorder.isAllowed {
						if voiceRecorder.isRecording {
							voiceRecorder.stopRecording()
						} else {
							voiceRecorder.startRecording(trackManager.nextNumber(for: nil)) {
								trackManager.createVoiceTrack()
							}
						}
					} else {
						isMicrophoneAlertPresented = true
					}
				}
				.foregroundStyle(voiceRecorder.isRecording ? .red : .black)
				.alert(
					"microphoneNotGranted",
					isPresented: $isMicrophoneAlertPresented,
					actions: {
						Button("OK", action: {})
					}
				)

				SquareButton(Icons.record) {
					if trackManager.isFullRecording {
						trackManager.stopFullRecording()
					} else {
						trackManager.startFullRecording { url in
							urlToShare = url
						}
					}
				}
				.foregroundStyle(trackManager.isFullRecording ? .red : .black)

				SquareButton(trackManager.isFullPlaying ? Icons.pause : Icons.play) {
					if trackManager.isFullPlaying {
						trackManager.stopCombinedTracks()
					} else {
						trackManager.playCombinedTracks()
					}
				}
			}
			.foregroundStyle(.black)
		}
		.padding(15)
		.documentInteractionCover($urlToShare)
	}
}

#Preview {
	ContentView()
}
