//
//  TracksView.swift
//  YandexMusicApp
//
//  Created by Евгений on 3.11.23.
//

import SwiftUI

struct TracksView: View {
	@ObservedObject var trackManager: TrackManager
	@State private var mainFrame: CGRect = .zero
	@Binding var isPresented: Bool
	var maxHeight: CGFloat

    var body: some View {
		ScrollView(.vertical, showsIndicators: false) {
			Group {
				if trackManager.tracks.isEmpty {
					HStack {
						Spacer()
						Text("noLayersAdded")
							.font(.ysTextBody)
							.foregroundStyle(.black)
						Spacer()
					}
					.padding()
					.background(Colors.trackBackground)
					.cornerRadius(Constants.globalCornerRadius)
					.shadow(color: Color.gray, radius: 5)
				} else {
					VStack {
						Spacer()
						ForEach(trackManager.tracks) { track in
							TrackView(track, manager: trackManager, mainFrame: $mainFrame)
								.transition(
									.move(edge: .bottom)
										.combined(with: .opacity)
								)
						}
					}
					.frame(minHeight: mainFrame.height - 20)
				}
			}
			.padding(10)
		}
		.transition(
			.move(edge: .bottom)
				.combined(with: .opacity)
		)
		.padding(.horizontal, -10)
		.overlay {
			VStack {
				Spacer()
				LinearGradient(
					colors: [Colors.background.opacity(0), Colors.background],
					startPoint: .top,
					endPoint: .bottom
				)
					.frame(height: 10)
			}
		}
		.background {
			GeometryReader { proxy -> Color in
				if isPresented {
					DispatchQueue.main.async {
						mainFrame = proxy.frame(in: .global)
							.inset(by: .init(
								top: proxy.size.height - maxHeight,
								left: 0,
								bottom: 0,
								right: 0
							))
					}
				}

				return Color.clear
			}
		}
		.frame(maxHeight: maxHeight, alignment: .bottom)
		.fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
	TracksView(trackManager: .init(sampleManager: SampleManager()), isPresented: .constant(true), maxHeight: 200)
}
