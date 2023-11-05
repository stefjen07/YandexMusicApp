//
//  InstrumentType.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

enum InstrumentType: String, Identifiable, CaseIterable {
	case guitar
	case drums
	case brass

	init(id: Int) {
		switch id {
		case 1:
			self = .guitar
		case 2:
			self = .drums
		default:
			self = .brass
		}
	}

	var id: Int {
		switch self {
		case .guitar:
			1
		case .drums:
			2
		case .brass:
			3
		}
	}

	var icon: Image {
		switch self {
		case .guitar:
			Icons.guitar
		case .drums:
			Icons.drums
		case .brass:
			Icons.brass
		}
	}

	var name: LocalizedStringKey {
		switch self {
		case .guitar:
			"guitar"
		case .drums:
			"drums"
		case .brass:
			"brass"
		}
	}
}
