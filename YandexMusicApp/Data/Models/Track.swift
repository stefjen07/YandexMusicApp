//
//  Track.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

enum TrackType {
	case instrument(InstrumentType, sample: Int)
	case voice

	func name(_ index: Int) -> LocalizedStringKey {
		switch self {
		case .instrument(let instrumentType, _):
			return switch instrumentType {
			case .guitar:
				"guitarTrack \(index)"
			case .drums:
				"drumsTrack \(index)"
			case .brass:
				"brassTrack \(index)"
			}
		case .voice:
			return "voiceTrack \(index)"
		}
	}
}

class Track: ObservableObject, Identifiable {
	@Published var isMuted = false
	@Published var speed: Double
	@Published var volume: Double

	var id = UUID()
	var type: TrackType
	var number: Int

	init(_ type: TrackType, number: Int, speed: Double, volume: Double, isMuted: Bool = false) {
		self.type = type
		self.number = number
		self.speed = speed
		self.volume = volume
		self.isMuted = isMuted
	}

	var name: LocalizedStringKey {
		type.name(number)
	}

	private func getVoiceUrl(_ id: Int) -> URL? {
		URL.documentsDirectory?.appendingPathComponent("voice\(id)", conformingTo: .wav)
	}

	func getUrl(sampleRepository: SampleRepositoryProtocol) -> URL? {
		switch type {
		case .instrument(let instrumentType, let sample):
			return sampleRepository.getSample(instrumentType, sample: sample)
		case .voice:
			return getVoiceUrl(number)
		}
	}
}
