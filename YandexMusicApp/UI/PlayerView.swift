//
//  PlayerView.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
	@Environment(\.dismiss) var dismiss

	@State private var isNameAlertPresented = false
	@State private var newTrackName = String(localized: "newName")
	@State private var currentTime = Double.zero
	@State private var urlToShare: URL?
	@State private var recordedTrack: MusicTrack?

	@State var timer: Timer?

	private var recordedTrackPlayer: AVPlayer?

	var trackManager: TrackManager


	var duration: Double {
		let result = recordedTrackPlayer?.currentItem?.duration.seconds ?? 0

		return result.isNormal ? result : 0
	}

	var isPlaying: Bool {
		if let recordedTrackPlayer {
			return recordedTrackPlayer.timeControlStatus == .playing
		}

		return true
	}

	init(trackManager: TrackManager, recordedTrack: MusicTrack? = nil) {
		self.trackManager = trackManager
		self.recordedTrack = recordedTrack

		if let recordedTrack {
			self.recordedTrackPlayer = AVPlayer(url: recordedTrack.url)
			self.recordedTrackPlayer?.play()

			self.newTrackName = recordedTrack.name
		}
	}

    var body: some View {
		VStack(spacing: 14) {
			HStack {
				NavigationBarButton(icon: Icons.arrow, color: Colors.padBackground) {
					dismiss()
				}
				Button(action: {
					isNameAlertPresented = true
				}, label: {
					Text(recordedTrack?.name ?? newTrackName)
						.foregroundColor(.primary)
						.font(.ysTextTitle)
				})

				Spacer()

				if let recordedTrack {
					NavigationBarButton(icon: Icons.download, color: Colors.selection) {
						urlToShare = recordedTrack.url
					}
				}
			}

			AudioVisualizerView(trackManager: trackManager, player: recordedTrackPlayer)

			if let recordedTrackPlayer {
				Slider($currentTime, maximumValue: duration, onValueChanged: {
					recordedTrackPlayer.seek(to: .init(seconds: $0, preferredTimescale: 60))
				})

				HStack(spacing: 13) {
					Text(currentTime.timeFormatted)

					Spacer()

					Button(action: {
						recordedTrackPlayer.seek(to: .zero)
					}, label: {
						Icons.rewindBack
							.resizable()
							.aspectRatio(contentMode: .fit)
					})
					Button(action: {
						if isPlaying {
							recordedTrackPlayer.pause()
						} else {
							recordedTrackPlayer.play()
						}
					}, label: {
						(isPlaying ? Icons.pause : Icons.play)
							.renderingMode(.template)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.foregroundColor(Colors.selection)
					})
					Button(action: {
						if let duration = recordedTrackPlayer.currentItem?.duration {
							recordedTrackPlayer.seek(to: duration, toleranceBefore: .zero, toleranceAfter: .zero)
						}
					}, label: {
						Icons.rewindForward
							.resizable()
							.aspectRatio(contentMode: .fit)
					})

					Spacer()

					Text(duration.timeFormatted)
				}
				.font(.ysTextBody)
				.frame(height: 16)
			}
		}
		.padding(.horizontal, 15)
		.padding(.top, 15)
		.padding(.bottom, 27)
		.background(Colors.background)
		.alert("newName", isPresented: $isNameAlertPresented, actions: {
			TextField("newName", text: $newTrackName)
				.onChange(of: newTrackName) {
					self.recordedTrack?.name = $0
				}
		}, message: {
			Text("enterNewName")
		})
		.documentInteractionCover($urlToShare)
		.toolbar(.hidden, for: .navigationBar)
		.onAppear {
			timer = Timer.scheduledTimer(withTimeInterval: (0.1...0.25).nearestValue(to: duration * 0.1), repeats: true) { _ in
				DispatchQueue.main.async {
					currentTime = recordedTrackPlayer?.currentTime().seconds ?? 0
				}
			}
		}
		.onDisappear {
			timer?.invalidate()
		}
    }
}

#Preview {
	PlayerView(
		trackManager: .init(sampleManager: SampleManager())
	)
}
