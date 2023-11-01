//
//  TrackView.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct TrackView: View {
	@ObservedObject var track: Track
	@ObservedObject var manager: TrackManager

	init(_ track: Track, manager: TrackManager) {
		self.track = track
		self.manager = manager
	}

	var isSelected: Bool {
		manager.selectedTrack?.id == track.id
	}

	var isNowPlaying: Bool {
		manager.nowPlayingTrack?.id == track.id
	}

	var body: some View {
		HStack(spacing: 0) {
			HStack(spacing: 15) {
				Button(action: {
					manager.selectedTrack = track
				}, label: {
					HStack {
						Text(track.name)
							.foregroundStyle(.black)
							.font(.ysTextBody)
						Spacer()
					}
				})

				Button(action: {
					manager.nowPlayingTrack = isNowPlaying ? nil : track
				}, label: {
					isNowPlaying ? Icons.pause : Icons.play
				})

				Button(action: {
					track.isMuted.toggle()
				}, label: {
					(track.isMuted ? Icons.unmute : Icons.mute)
						.frame(width: 17)
				})
			}
			.padding(11)

			Button(action: {
				withAnimation {
					manager.removeTrack(id: track.id)
				}
			}, label: {
				Icons.xmark
					.padding(13)
					.background(Colors.xmarkBackground)
					.cornerRadius(Constants.globalCornerRadius)
			})
		}
		.background(isSelected ? Colors.selection : Colors.trackBackground)
		.cornerRadius(Constants.globalCornerRadius)
		.shadow(color: Color.gray, radius: 5)
	}
}

#Preview {
	TrackView(.init(.instrument(.drums, sample: 1), number: 1), manager: .init())
}
