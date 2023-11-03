//
//  TracksView.swift
//  YandexMusicApp
//
//  Created by Евгений on 3.11.23.
//

import SwiftUI

struct TracksView: View {
	@ObservedObject var trackManager: TrackManager
	@State var mainFrame: CGRect = .zero

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
						ForEach(trackManager.tracks) { track in
							TrackView(track, manager: trackManager, mainFrame: $mainFrame)
						}
					}
				}
			}
			.padding(10)
		}
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
				DispatchQueue.main.async {
					mainFrame = proxy.frame(in: .global)
				}

				return Color.clear
			}
		}
		.transition(
			.move(edge: .bottom)
			.combined(with: .opacity)
		)
    }
}

#Preview {
	TracksView(trackManager: .init())
}
