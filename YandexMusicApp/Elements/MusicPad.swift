//
//  MusicPad.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct MusicPad: View {
	private let leadingScaleCount = 26
	private let bottomScaleCount = 26
	private let bottomScalePower = 2

	@State var scaleOffset = CGPoint.zero

    var body: some View {
		GeometryReader { proxy in
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
									Color.white
										.frame(width: 1)
										.offset(
											x: proxy.size.width *
											pow(CGFloat(i), CGFloat(bottomScalePower)) /
											pow(CGFloat(bottomScaleCount - 1), CGFloat(bottomScalePower))
										)
								}
							}
						}
						.frame(height: 8)
						.scaleEffect(x: -1, y: 1)
						.padding(.leading, 25)

						Slider("скорость")
							.offset(x: scaleOffset.x)
					}
				}

				HStack {
					ZStack(alignment: .topLeading) {
						VStack(alignment: .leading, spacing: 0) {
							ForEach(0..<leadingScaleCount) { i in
								Color.white
									.frame(width: i % 5 == 0 ? 16 : 8, height: 1)
								if i != leadingScaleCount - 1 {
									Spacer()
								}
							}
						}

						Slider("громкость", isVertical: true)
							.offset(y: scaleOffset.y)
					}
					Spacer()
				}
				.padding(.bottom, 25)
			}
			.onAppear {
				scaleOffset = proxy.frame(in: .local).midPoint
			}
			.gesture(
				DragGesture(minimumDistance: 0, coordinateSpace: .local)
					.onChanged { value in
						let widthOffset = Constants.sliderWidth * 0.5

						scaleOffset = proxy
							.frame(in: .local)
							.insetBy(dx: widthOffset, dy: widthOffset)
							.inset(by: .init(top: 0, left: 25, bottom: 25, right: 0))
							.nearestPoint(to: value.location)
							.applying(.init(translationX: -widthOffset, y: -widthOffset))

						print(scaleOffset)
					}
			)
		}
    }
}

#Preview {
    MusicPad()
}
