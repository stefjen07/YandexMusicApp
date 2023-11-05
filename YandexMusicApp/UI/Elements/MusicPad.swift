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
	private let dispatchGroup = DispatchGroup()

	let trackManager: TrackManager

	var bottomScaleValues: [CGFloat] {
		return (0..<bottomScaleCount).map {
			pow(CGFloat($0), bottomScalePower) /
			pow(CGFloat(bottomScaleCount - 1), bottomScalePower)
		}
	}

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
							GeometryReader { proxy in
								ZStack {
									ForEach(bottomScaleValues, id: \.self) { value in
										Color.primary
											.frame(width: 1)
											.offset(
												x: proxy.size.width * value
											)
									}
								}
							}
							.frame(height: 8)
							.frame(height: isMoving ? 14 : 8)
							.animation(.easeInOut, value: isMoving)
							.scaleEffect(x: -1, y: 1)
							.padding(.horizontal, Constants.sliderCornerRadius)

							Slider("speed")
								.offset(x: scaleOffset.x)
						}
						.padding(.leading, Constants.sliderLeftBottomPadding)
					}

					HStack {
						ZStack(alignment: .topLeading) {
							VStack(alignment: .leading, spacing: 0) {
								ForEach(0..<leadingScaleCount, id: \.self) { i in
									Color.primary
										.frame(width: i % 5 == 0 ? 14 : 8, height: 1)
									if i != leadingScaleCount - 1 {
										Spacer()
									}
								}
							}
							.padding(.vertical, Constants.sliderCornerRadius)

							Slider("volume", isVertical: true)
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
