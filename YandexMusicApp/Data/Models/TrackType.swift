//
//  TrackType.swift
//  YandexMusicApp
//
//  Created by Евгений on 4.11.23.
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
