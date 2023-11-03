//
//  TrackManager.swift
//  YandexMusicApp
//
//  Created by Евгений on 1.11.23.
//

import SwiftUI
import AVFoundation

class TrackManager: ObservableObject {
	@Published var tracks: [Track] = []
	@Published var nowPlayingTrack: Track? {
		didSet {
			handleNowPlayingTrack()
		}
	}
	@Published var selectedTrack: Track?

	@Published var isFullPlaying = false
	@Published var isFullRecording = false

	@Published var defaultVolume: CGFloat = 1
	@Published var defaultSpeed: CGFloat = 1

	private let trackCombiner: TrackCombinerProtocol = TrackCombiner()
	private let sampleRepository: SampleRepositoryProtocol = SampleRepository()
	private var trackPlayer: AVQueuePlayer?
	private var looper: AVPlayerLooper?

	var volume: Binding<CGFloat> {
		Binding(get: { [unowned self] in
			selectedTrack?.volume ?? defaultVolume
		}, set: { [unowned self] in
			if let selectedTrack = selectedTrack {
				selectedTrack.volume = $0
			}

			defaultVolume = $0
		})
	}

	var speed: Binding<CGFloat> {
		Binding(get: { [unowned self] in
			selectedTrack?.speed ?? defaultSpeed
		}, set: { [unowned self] in
			if let selectedTrack = selectedTrack {
				selectedTrack.speed = $0
			}

			defaultSpeed = $0
		})
	}

	func nextNumber(for instrument: InstrumentType?) -> Int {
		var number = 1

		while tracks
			.filter({
				return switch $0.type {
				case .instrument(let instrumentType, _):
					instrumentType == instrument
				case .voice:
					instrument == nil
				}
			})
			.contains(where: {
				$0.number == number
			})
		{
			number += 1
		}

		return number
	}

	func createInstrumentTrack(_ instrument: InstrumentType, sample: Int) {
		let newNumber = nextNumber(for: instrument)
		let newTrack = Track(.instrument(instrument, sample: sample), number: newNumber, speed: defaultSpeed, volume: defaultVolume)

		addTrack(newTrack)
	}

	func createVoiceTrack() {
		let newNumber = nextNumber(for: nil)
		let newTrack = Track(.voice, number: newNumber, speed: defaultSpeed, volume: defaultVolume)

		addTrack(newTrack)
	}

	func addTrack(_ track: Track) {
		tracks.append(track)
		selectedTrack = track
	}

	func removeTrack(id: UUID) {
		tracks.removeAll(where: { $0.id == id })
	}

	func handleNowPlayingTrack() {
		DispatchQueue.main.async { [unowned self] in
			if let nowPlayingTrack, let url = nowPlayingTrack.getUrl(sampleRepository: sampleRepository) {
				let item = AVPlayerItem(url: url)
				trackPlayer = AVQueuePlayer(playerItem: item)

				if let trackPlayer {
					trackPlayer.volume = Float(nowPlayingTrack.volume)
					looper = AVPlayerLooper(player: trackPlayer, templateItem: item)
					trackPlayer.playImmediately(atRate: Float(nowPlayingTrack.speed))
				}

				nowPlayingTrack.isMuted = false
			} else {
				trackPlayer = nil
				looper = nil
			}
		}
	}

	func playCombinedTracks() {
		DispatchQueue.main.async { [unowned self] in
			trackCombiner.playCombinedTracks(tracks)
			isFullPlaying = true
		}
	}

	func stopCombinedTracks() {
		DispatchQueue.main.async { [unowned self] in
			trackCombiner.stopCombinedTracks()
			isFullPlaying = false
		}
	}

	func startFullRecording(completionHandler: @escaping (URL) -> Void) {
		DispatchQueue.main.async { [unowned self] in
			trackCombiner.playAndRecordCombinedTracks(tracks, completionHandler: completionHandler)
			isFullRecording = true
		}
	}

	func stopFullRecording() {
		DispatchQueue.main.async { [unowned self] in
			trackCombiner.stopCombinedTracks()
			isFullRecording = false
		}
	}
}
