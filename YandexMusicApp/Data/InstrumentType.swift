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

	var id: Int {
		hashValue
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

	var name: String {
		switch self {
		case .guitar:
			"гитара"
		case .drums:
			"ударные"
		case .brass:
			"духовые"
		}
	}
}
