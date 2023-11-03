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

	@State var isDropdownMenuOpened = false
	@State var isMicrophoneAlertPresented = false
	@State var urlToShare: URL?
	@State var openedInstrument: InstrumentType?

    var body: some View {
		VStack(spacing: 21) {
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

				MusicPad(volume: trackManager.volume, speed: trackManager.speed)
					.padding(.top, 120)
					.zIndex(-1)

				VStack(spacing: 7) {
					Spacer()

					if isDropdownMenuOpened {
						Group {
							if trackManager.tracks.isEmpty {
								HStack {
									Spacer()
									Text("noLayersAdded")
										.font(.ysTextBody)
										.foregroundStyle(.black)
									Spacer()
								}
								.padding()
								.background(Colors.trackBackground)
								.cornerRadius(Constants.globalCornerRadius)
								.shadow(color: Color.gray, radius: 5)
							} else {
								VStack {
									ForEach(trackManager.tracks) { track in
										TrackView(track, manager: trackManager)
									}
								}
							}
						}
						.transition(
							.move(edge: .bottom)
								.combined(with: .opacity)
						)
					}
				}
			}

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
