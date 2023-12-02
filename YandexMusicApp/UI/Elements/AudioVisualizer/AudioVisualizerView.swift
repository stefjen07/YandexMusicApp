//
//  AudioVisualizerView.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import SwiftUI
import AVFoundation

struct AudioVisualizerView: View {
	@ObservedObject var audioVisualizerManager: AudioVisualizerManager

    var body: some View {
		VStack {
			GeometryReader { proxy in
				ZStack {
					ForEach(audioVisualizerManager.items) { item in
						let width: CGFloat = 60
						let height: CGFloat = 60
						let imageSize = CGFloat(sqrt(pow(width, 2) + pow(height, 2)))

						item.image
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: imageSize, height: imageSize)
							.rotation3DEffect(
								.radians(audioVisualizerManager.is3D ? item.rotation : 0),
								axis: (0.33, 0.33, 0.33)
							)
							.rotationEffect(.radians(audioVisualizerManager.is3D ? 0 : item.rotation))
							.offset(x: item.point.x * (proxy.size.width - imageSize), y: item.point.y * (proxy.size.height - imageSize))
					}
				}
			}
			Button(action: {
				audioVisualizerManager.is3D.toggle()
			}, label: {
				Text(audioVisualizerManager.is3D ? "3D" : "2D")
					.font(.ysTextBody)
					.foregroundStyle(.black)
					.padding(.horizontal, 10)
					.frame(height: 34)
					.background(Colors.buttonBackground)
					.cornerRadius(Constants.globalCornerRadius)
			})
		}
    }
}

#Preview {
	AudioVisualizerView(audioVisualizerManager: .init(trackManager: .init(sampleManager: SampleManager()), player: nil))
}
