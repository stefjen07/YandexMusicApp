//
//  Colors.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

enum ChevronDirection: Int {
	case down = 0
	case left
	case up
	case right
}

class Colors {
	static let selection = Color("selection")

	static let background = Color("background")
	static let trackBackground = Color("track-background")
	static let xmarkBackground = Color("xmark-background")
	static let buttonBackground = Color("button-background")
	static let padBackground = Color("pad-background")
}
