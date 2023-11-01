//
//  TrackManager.swift
//  YandexMusicApp
//
//  Created by Евгений on 1.11.23.
//

import Foundation

class TrackManager: ObservableObject {
	@Published var tracks: [Track] = []
	@Published var nowPlayingTrack: Track?
	@Published var selectedTrack: Track?

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
		let newTrack = Track(.instrument(instrument, sample: sample), number: newNumber, isMuted: false)

		addTrack(newTrack)
	}

	func addTrack(_ track: Track) {
		tracks.append(track)
		selectedTrack = track
	}

	func removeTrack(id: UUID) {
		tracks.removeAll(where: { $0.id == id })
	}
}
