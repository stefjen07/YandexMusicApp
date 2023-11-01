//
//  SampleRepository.swift
//  YandexMusicApp
//
//  Created by Евгений on 1.11.23.
//

import Foundation

typealias Sample = Data

protocol SampleRepositoryProtocol {
	func getSamples() -> [Sample]
	func getSamples(_ instrument: InstrumentType) -> [Sample]
	func getSample(_ instrument: InstrumentType, sample: Int) -> Sample?
}

class SampleRepository: SampleRepositoryProtocol {
	var samples: [InstrumentType: [Sample]] = [:]

	init() {
		loadSamples()
	}

	func loadSamples() {
		for type in InstrumentType.allCases {
			samples[type] = []

			for index in 1..<4 {
				if let url = Bundle.main.url(forResource: "\(type.name)\(index)", withExtension: "wav"),
				   let data = try? Data(contentsOf: url)
				{
					samples[type]?.append(data)
				}
			}
		}
	}

	func getSamples() -> [Sample] {
		samples.values.flatMap { $0 }
	}

	func getSamples(_ instrument: InstrumentType) -> [Sample] {
		samples[instrument] ?? []
	}

	func getSample(_ instrument: InstrumentType, sample: Int) -> Sample? {
		guard let instrumentSamples = samples[instrument],
			  (0..<instrumentSamples.count).contains(sample)
		else {
			return nil
		}

		return instrumentSamples[sample]
	}
}
