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

	private var playerTimer: Timer?

	init(sampleRepository: SampleRepositoryProtocol = SampleRepository()) {
		self.avPlayer = AVPlayer()
		self.sampleRepository = sampleRepository
	}

	func playSamplePreview(_ instrument: InstrumentType, sample: Int, duration: Double? = nil) {
		if let url = sampleRepository.getSample(instrument, sample: sample) {
			playerTimer?.invalidate()
			
			avPlayer.replaceCurrentItem(with: .init(url: url))
			avPlayer.play()

			if let duration {
				playerTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [unowned self] _ in
					stopSamplePreview()
				}
			}
		}
	}

	func stopSamplePreview() {
		avPlayer.replaceCurrentItem(with: nil)
		playerTimer?.invalidate()
	}

	func getSamplesIndices(_ instrument: InstrumentType) -> [Int] {
		return sampleRepository.getSamples(instrument).indices.map { $0 }
	}
}
