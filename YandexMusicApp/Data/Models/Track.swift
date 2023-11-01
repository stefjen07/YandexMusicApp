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
	var id = UUID()
	var type: TrackType
	var number: Int

	var name: LocalizedStringKey {
		type.name(number)
	}

	init(_ type: TrackType, number: Int, isMuted: Bool = false) {
		self.type = type
		self.number = number
		self.isMuted = isMuted
	}
}
