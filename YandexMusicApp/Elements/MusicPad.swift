//
//  MusicPad.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct MusicPad: View {
	@Binding var volume: CGFloat
	@Binding var speed: CGFloat

	private let leadingScaleCount = 26
	private let bottomScaleCount = 26
	private let bottomScalePower = 2

	@State var isMoving = false

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

				VStack {
					Spacer()
					ZStack(alignment: .bottomLeading) {
						GeometryReader { proxy in
							ZStack {
								ForEach(0..<bottomScaleCount) { i in
									Color.primary
										.frame(width: 1)
										.offset(
											x: proxy.size.width *
											pow(CGFloat(i), CGFloat(bottomScalePower)) /
											pow(CGFloat(bottomScaleCount - 1), CGFloat(bottomScalePower))
										)
								}
							}
						}
						.frame(height: isMoving ? 14 : 8)
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
							ForEach(0..<leadingScaleCount) { i in
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
			.gesture(
				DragGesture(minimumDistance: 0, coordinateSpace: .local)
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

						if !isMoving {
							withAnimation {
								isMoving = true
							}
						}
					}
					.onEnded { _ in
						withAnimation {
							isMoving = false
						}
					}
			)
		}
    }
}

struct MusicPadPreview: View {
	@State var volume: CGFloat = 1.0
	@State var speed: CGFloat = 1.0

	var body: some View {
		MusicPad(volume: $volume, speed: $speed)
	}
}

#Preview {
	MusicPadPreview()
}
