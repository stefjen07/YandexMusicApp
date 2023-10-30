//
//  Manager.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import Foundation

class Manager {
	var samples: [InstrumentType: [Data]] = [:]

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
}
