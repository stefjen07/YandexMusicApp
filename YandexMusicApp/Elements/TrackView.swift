//
//  TrackView.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct TrackView: View {
	@ObservedObject var track: Track

	init(_ track: Track) {
		self.track = track
	}

	var body: some View {
		HStack(spacing: 0) {
			HStack(spacing: 15) {
				Text(track.type.name(1))
					.foregroundStyle(.black)
					.font(.ysTextBody)
				Spacer()
				Icons.play

				Button(action: {
					track.isMuted.toggle()
				}, label: {
					(track.isMuted ? Icons.unmute : Icons.mute)
						.frame(width: 17)
				})
			}
			.padding(11)

			Button(action: {

			}, label: {
				Icons.xmark
					.padding(13)
					.background(Colors.xmarkBackground)
					.cornerRadius(Constants.globalCornerRadius)
			})
		}
		.background(Colors.trackBackground)
		.cornerRadius(Constants.globalCornerRadius)
	}
}

#Preview {
	TrackView(.init(.insturment(.drums)))
}
