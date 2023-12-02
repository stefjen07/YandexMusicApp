//
//  MusicPad.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct MusicPad: View {
	@Environment(\.isEnabled) var isEnabled: Bool

	@Binding var volume: CGFloat
	@Binding var speed: CGFloat

	@State private var isMoving = false

	private let leadingScaleCount = 26
	private let bottomScaleCount = 26
	private let bottomScalePower: CGFloat = 2

	let trackManager: TrackManager

    var body: some View {
		GeometryReader { proxy in
			let widthOffset = Constants.sliderWidth * 0.5

			let scaleFrame = proxy.frame(in: .local)
				.inset(by: .init(
					top: 0,
					left: Constants.sliderLeftBottomPadding,
					bottom: Constants.sliderLeftBottomPadding,
					right: 0
				))
				.insetBy(dx: widthOffset, dy: widthOffset)
				.applying(.init(
					scaleX: Constants.speedRange.mapToIdentity(speed),
					y: 1 - Constants.volumeRange.mapToIdentity(volume)
				))
			let scaleOffset = CGPoint(x: scaleFrame.width, y: scaleFrame.height)

			ZStack {
				LinearGradient(
					colors: [Colors.padBackground.opacity(0), Colors.padBackground],
					startPoint: .top,
					endPoint: .bottom
				)

				if isEnabled {
					VStack {
						Spacer()
						ZStack(alignment: .bottomLeading) {
							Canvas { renderer, size in
								var path = Path()

								for i in 0..<bottomScaleCount {
									let x = 0.5 + pow(CGFloat(i), bottomScalePower) / pow(CGFloat(bottomScaleCount - 1), bottomScalePower) * (size.width - 1)
									path.move(to: .init(x: x, y: 0))
									path.addLine(to: .init(x: x, y: size.height))
								}

								renderer.stroke(path, with: .color(.primary))
							}
							.frame(height: isMoving ? 14 : 8)
							.scaleEffect(x: -1, y: 1)
							.padding(.horizontal, Constants.sliderCornerRadius)

							MusicPadSlider("speed")
								.offset(x: scaleOffset.x)
						}
						.padding(.leading, Constants.sliderLeftBottomPadding)
					}

					HStack {
						ZStack(alignment: .topLeading) {
							Canvas { renderer, size in
								var path = Path()
								for i in 0..<leadingScaleCount {
									let y = 0.5 + CGFloat(i) / CGFloat(leadingScaleCount - 1) * (size.height - 1)
									path.move(to: .init(x: 0, y: y))
									path.addLine(to: .init(x: i % 5 == 0 ? 14 : 8, y: y))
								}
								renderer.stroke(path, with: .color(.primary))
							}
							.frame(width: 14)
							.padding(.vertical, Constants.sliderCornerRadius)

							MusicPadSlider("volume", isVertical: true)
								.offset(y: scaleOffset.y)
						}
						Spacer()
					}
					.padding(.bottom, Constants.sliderLeftBottomPadding)
				}
			}
			.gesture(
				DragGesture(minimumDistance: isEnabled ? 0 : .infinity, coordinateSpace: .local)
					.onChanged { value in
						let slidableFrame = proxy
							.frame(in: .local)
							.insetBy(dx: widthOffset, dy: widthOffset)
							.inset(by: .init(
								top: 0,
								left: Constants.sliderLeftBottomPadding,
								bottom: Constants.sliderLeftBottomPadding,
								right: 0
							))

						let values = slidableFrame
							.nearestPoint(to: value.location)
							.applying(.init(translationX: -slidableFrame.minX, y: -slidableFrame.minY))
							.applying(.init(scaleX: 1.0 / slidableFrame.width, y: 1.0 / slidableFrame.height))

						speed = Constants.speedRange.mapFromIdentity(values.x)
						volume = Constants.volumeRange.mapFromIdentity(1 - values.y)

						if trackManager.nowPlayingTrack == nil,
						   let selectedTrack = trackManager.selectedTrack
						{
							trackManager.playTrack(selectedTrack)
						}

						if !isMoving {
							withAnimation(.linear(duration: Constants.sliderAnimationDuration)) {
								isMoving = true
							}
						}
					}
					.onEnded { _ in
						trackManager.stopTrack()

						withAnimation(.linear(duration: Constants.sliderAnimationDuration)) {
							isMoving = false
						}
					}
			)
		}
    }
}

struct MusicPadPreview: View {
	@State private var volume: CGFloat = 1.0
	@State private var speed: CGFloat = 1.0

	var body: some View {
		MusicPad(volume: $volume, speed: $speed, trackManager: .init(sampleManager: SampleManager()))
	}
}

#Preview {
	MusicPadPreview()
}
