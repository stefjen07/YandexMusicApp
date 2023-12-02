//
//  ContentView.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct ContentView: View {
	let sampleManager: SampleManagerProtocol = SampleManager()
	@ObservedObject var trackManager: TrackManager
	@ObservedObject var audioVisualizerManager: AudioVisualizerManager
	@ObservedObject var voiceRecorder: VoiceRecorder = .init()

	@State private var outputFileType: OutputFileType = .current
	@State private var isDropdownMenuOpened = false
	@State private var isMicrophoneAlertPresented = false
	@State private var recordedTrackUrl: URL?
	@State private var openedInstrument: InstrumentType?
	@State private var isPlayerOpened = false

	init() {
		let trackManager = TrackManager(sampleManager: sampleManager)
		self.trackManager = trackManager
		self.audioVisualizerManager = .init(trackManager: trackManager, player: nil)
	}

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
					.zIndex(2000)

					ZStack {
						MusicPad(volume: trackManager.volume, speed: trackManager.speed, trackManager: trackManager)
							.disabled(isDropdownMenuOpened || trackManager.isFullPlaying || trackManager.isFullRecording)
							.padding(.top, 120)

						if trackManager.isFullPlaying || trackManager.isFullRecording {
							Button(action: {
								isPlayerOpened = true
							}, label: {
								Text("goToVisualizer")
									.foregroundStyle(Color.primary)
									.font(.ysTextTitle)
									.padding()
									.background(Colors.selection)
									.cornerRadius(6)
							})
						}
					}

					if isDropdownMenuOpened {
						VStack {
							Spacer()
							TracksView(
								trackManager: trackManager,
								isPresented: $isDropdownMenuOpened,
								maxHeight: (proxy.size.height - 120) * 0.8
							)
						}
						.offset(y: Constants.audioWaveHeight + 21)
						.zIndex(1000)
					}

				}
			}
			.zIndex(1000)

			AudioWaveView(trackManager: trackManager)

			HStack {
				DropdownMenuButton("layers", isOpened: $isDropdownMenuOpened)

				Spacer()

				Button(action: {
					outputFileType = outputFileType.next
				}, label: {
					Text(outputFileType.name)
						.font(.ysTextBody)
						.foregroundStyle(.black)
						.padding(.horizontal, 10)
						.frame(height: 34)
						.background(Colors.buttonBackground)
						.cornerRadius(Constants.globalCornerRadius)
				})
				.onChange(of: outputFileType) {
					OutputFileType.current = $0
				}

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
				.disabled(trackManager.isFullPlaying || trackManager.isFullRecording)
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
							recordedTrackUrl = url
							isPlayerOpened = true
						}
					}
				}
				.disabled(voiceRecorder.isRecording)
				.foregroundStyle(trackManager.isFullRecording ? .red : .black)

				SquareButton(trackManager.isFullPlaying ? Icons.pause : Icons.play) {
					if trackManager.isFullPlaying {
						trackManager.stopCombinedTracks()
					} else {
						trackManager.playCombinedTracks()
					}
				}
				.disabled(voiceRecorder.isRecording)
			}
			.foregroundStyle(.black)
		}
		.padding(15)
		.onTapGesture {
			if isDropdownMenuOpened {
				withAnimation {
					isDropdownMenuOpened = false
				}
			}
		}
		.onChange(of: isDropdownMenuOpened) {
			if !$0 {
				trackManager.stopTrack()
			}
		}
		.navigationDestination(isPresented: $isPlayerOpened) {
			if let recordedTrackUrl {
				PlayerView(trackManager: trackManager, audioVisualizerManager: audioVisualizerManager, recordedTrack: .init(url: recordedTrackUrl))
					.onDisappear {
						self.recordedTrackUrl = nil
					}
			} else {
				PlayerView(trackManager: trackManager, audioVisualizerManager: audioVisualizerManager)
			}
		}
	}
}

#Preview {
	NavigationStack {
		ContentView()
	}
}
