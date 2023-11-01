//
//  Manager.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import Foundation

class Manager: ObservableObject {
	@Published private var sampleSelection: SampleSelection?

	private let sampleRepository: SampleRepositoryProtocol

	init(sampleRepository: SampleRepositoryProtocol = SampleRepository()) {
		self.sampleRepository = sampleRepository
	}

	var currentSample: Sample? {
		if let sampleSelection {
			return sampleRepository.getSample(sampleSelection.instrument, sample: sampleSelection.sample)
		}

		return nil
	}

	func selectSample(_ instrument: InstrumentType, sample: Int) {
		sampleSelection = .init(instrument: instrument, sample: sample)
	}
}
