//
//  SampleManager.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import Foundation
import Combine
import AVFoundation

class SampleManager {
	private let avPlayer: AVPlayer
	private let sampleRepository: SampleRepositoryProtocol

	init(sampleRepository: SampleRepositoryProtocol = SampleRepository()) {
		self.avPlayer = AVPlayer()
		self.sampleRepository = sampleRepository
	}

	func playSamplePreview(_ instrument: InstrumentType, sample: Int) {
		if let url = sampleRepository.getSample(instrument, sample: sample) {
			avPlayer.replaceCurrentItem(with: .init(url: url))
			avPlayer.play()
		}
	}

	func stopSamplePreview() {
		avPlayer.replaceCurrentItem(with: nil)
	}
}
