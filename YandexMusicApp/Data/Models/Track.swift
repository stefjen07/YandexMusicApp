//
//  Track.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

class Track: ObservableObject, Identifiable {
	@Published var isMuted = false
	@Published var speed: Double
	@Published var volume: Double

	let id: UUID
	let type: TrackType
	let number: Int

	init(id: UUID, type: TrackType, number: Int, speed: Double, volume: Double, isMuted: Bool) {
		self.id = id
		self.type = type
		self.number = number
		self.speed = speed
		self.volume = volume
		self.isMuted = self.isMuted
	}

	init(_ type: TrackType, number: Int, speed: Double, volume: Double, isMuted: Bool = false) {
		self.id = .init()
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
