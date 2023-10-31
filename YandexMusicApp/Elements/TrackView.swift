//
//  TrackView.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct TrackView: View {
	var track: Track

	init(_ track: Track) {
		self.track = track
	}

	var body: some View {
		HStack(spacing: 0) {
			HStack(spacing: 15) {
				Text(track.name)
					.font(.ysTextBody)
				Spacer()
				Icons.play
				Icons.unmute
			}
			.padding(11)

			Button(action: {

			}, label: {
				Icons.xmark
					.padding(13)
					.background(Colors.secondaryBackground)
					.cornerRadius(4)
			})
		}
		.background(.white)
		.cornerRadius(4)
	}
}

#Preview {
	TrackView(.init(name: "Ударные 1"))
}
