//
//  Track.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

enum TrackType {
	case insturment(InstrumentType)
	case voice

	func name(_ index: Int) -> LocalizedStringKey {
		switch self {
		case .insturment(let instrumentType):
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

class Track: ObservableObject {
	@Published var isMuted = false
	var type: TrackType

	init(_ type: TrackType, isMuted: Bool = false) {
		self.type = type
		self.isMuted = isMuted
	}
}
