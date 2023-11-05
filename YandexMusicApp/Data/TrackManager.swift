//
//  TrackManager.swift
//  YandexMusicApp
//
//  Created by Евгений on 1.11.23.
//

import SwiftUI
import AVFoundation

class TrackManager: ObservableObject {
	@Published var tracks: [Track] = [] {
		didSet {
			trackStorage.tracks = tracks
		}
	}
	@Published var nowPlayingTrack: Track?
	@Published var selectedTrack: Track?

	@Published var audioWave: [CGFloat] = []

	@Published var isFullPlaying = false
	@Published var isFullRecording = false

	@Published var defaultVolume: CGFloat = 1
	@Published var defaultSpeed: CGFloat = 1

	private var trackCombiner: TrackCombinerProtocol = TrackCombiner()
	private let trackWaveGenerator: TrackWaveGeneratorProtocol = TrackWaveGenerator()
	private var trackStorage: TrackStoraging = TrackStorage()
	private let sampleManager: SampleManagerProtocol
	private let sampleRepository: SampleRepositoryProtocol = SampleRepository()
	private var trackPlayer: AVQueuePlayer?
	private var looper: AVPlayerLooper?

	init(sampleManager: SampleManagerProtocol) {
		self.sampleManager = sampleManager

		trackCombiner.bufferHandler = { [unowned self] in
			if let value = trackWaveGenerator.processAudioData(buffer: $0) {
				DispatchQueue.main.async { [unowned self] in
					withAnimation(.linear) {
						audioWave.append(CGFloat(value))
					}
				}
			}
		}

		tracks = trackStorage.tracks
	}

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
		if let index = tracks.firstIndex(where: { $0.id == id }) {
			if case .voice = tracks[index].type,
			   let url = tracks[index].getUrl(sampleRepository: sampleRepository) {
				do {
					try FileManager.default.removeItem(at: url)
				} catch {
					print(error)
				}
			}

			tracks.remove(at: index)
		}
		tracks.removeAll(where: { $0.id == id })
	}

	func beforePlayingSwitch() {
		nowPlayingTrack = nil
		trackPlayer = nil
		looper = nil

		trackCombiner.stopCombinedTracks()
		sampleManager.stopSamplePreview()

		isFullPlaying = false
		isFullRecording = false
		audioWave = []
	}

	func playTrack(_ track: Track) {
		DispatchQueue.main.async { [unowned self] in
			if let url = track.getUrl(sampleRepository: sampleRepository) {
				beforePlayingSwitch()
				self.nowPlayingTrack = track
				let item = AVPlayerItem(url: url)
				trackPlayer = AVQueuePlayer(playerItem: item)

				if let trackPlayer {
					trackPlayer.volume = Float(track.volume)
					looper = AVPlayerLooper(player: trackPlayer, templateItem: item)
					trackPlayer.playImmediately(atRate: Float(track.speed))
				}

				track.isMuted = false
			}
		}
	}

	func stopTrack() {
		DispatchQueue.main.async { [unowned self] in
			nowPlayingTrack = nil
			trackPlayer = nil
			looper = nil
		}
	}

	func playCombinedTracks() {
		DispatchQueue.main.async { [unowned self] in
			beforePlayingSwitch()
			isFullPlaying = true
			trackCombiner.playCombinedTracks(tracks)
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
			beforePlayingSwitch()
			isFullRecording = true
			trackCombiner.playAndRecordCombinedTracks(tracks, completionHandler: completionHandler)
		}
	}

	func stopFullRecording() {
		DispatchQueue.main.async { [unowned self] in
			trackCombiner.stopCombinedTracks()
			isFullRecording = false
		}
	}
}
