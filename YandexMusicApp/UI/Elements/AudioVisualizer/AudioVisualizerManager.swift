//
//  AudioVisualizerManager.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import SwiftUI
import AVFoundation

class AudioVisualizerManager: ObservableObject {
	@Published var is3D = false
	@Published var items: [AudioVisualizerItem] = []
	var trackManager: TrackManager
	var player: AVPlayer?
	var timer: Timer?

	var isPaused: Bool {
		player?.timeControlStatus == .paused || (!trackManager.isFullPlaying && trackManager.isFullRecording)
	}

	var volume: Double {
		if let player {
			return isPaused ? 0 : Double(player.volume * 0.05)
		} else {
			return isPaused ? 0 : Double(trackManager.audioWave.last ?? 0)
		}
	}

	init(trackManager: TrackManager, player: AVPlayer?) {
		self.trackManager = trackManager
		self.player = player
		loadItems()
		startAnimating()
	}

	deinit {
		timer?.invalidate()
	}

	func loadItems() {
		items = AudioVisualizerItem.itemSet

		for i in items.indices {
			items[i].rotation = CGFloat.random(in: -.pi...Double.pi)
			items[i].point = .init(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))

			if items[i].isRotatable {
				items[i].rotationSpeed = CGFloat.random(in: -0.2...0.2)
			}
		}
	}

	func startAnimating() {
		timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
			withAnimation {
				for i in self.items.indices {
					self.items[i].acceleration.x += CGFloat.random(in: -1...1)
					self.items[i].acceleration.y += CGFloat.random(in: -1...1)
					self.items[i].acceleration = self.items[i].acceleration.nearestPoint(xBounds: -0.1...0.1, yBounds: -0.1...0.1)

					self.items[i].velocity += self.items[i].acceleration * 0.1
					self.items[i].velocity = self.items[i].velocity.nearestPoint(xBounds: -0.2...0.2, yBounds: -0.2...0.2)

					self.items[i].point += (self.items[i].velocity * (0.05 * self.volume))
					print(self.volume)

					if !(CGFloat.zero...1).contains(self.items[i].point.x) || !(CGFloat.zero...1).contains(self.items[i].point.y) {
						self.items[i].acceleration = .zero
						self.items[i].velocity = .zero
					}

					self.items[i].point = self.items[i].point.nearestPoint(xBounds: 0...1, yBounds: 0...1)

					self.items[i].rotation += (self.items[i].rotationSpeed * (0.05 * self.volume))
				}
			}
		}
	}
}
