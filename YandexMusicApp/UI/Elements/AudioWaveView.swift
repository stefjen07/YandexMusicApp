//
//  AudioWaveView.swift
//  YandexMusicApp
//
//  Created by Евгений on 3.11.23.
//

import SwiftUI

struct AudioWaveView: View {
	@ObservedObject var trackManager: TrackManager

    var body: some View {
		GeometryReader { proxy in
			let linesCount = Int(proxy.size.width / (2 + 2)) + 1

			HStack(alignment: .center, spacing: 0) {
				Spacer(minLength: 0)
					.padding(.trailing, -2)
				ForEach(trackManager.audioWave.suffixWithIndices(linesCount, filler: 1), id: \.index) {
					Color.primary
						.frame(width: 2, height: $0.value)
						.clipShape(Capsule())
						.padding(.leading, 2)
						.transition(.identity)
				}
			}
			.frame(height: Constants.audioWaveHeight)
		}
		.frame(height: Constants.audioWaveHeight)
    }
}

#Preview {
	AudioWaveView(trackManager: .init())
}
