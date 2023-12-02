//
//  Icons.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

class Icons {
	static let guitar = Image("guitar")
	static let drums = Image("drums")
	static let brass = Image("brass")

	static let record = Image("record")
	static let play = Image("play")
	static let pause = Image("pause")
	static let microphone = Image("microphone")

	static let mute = Image("mute")
	static let unmute = Image("unmute")

	static let xmark = Image("xmark")
	static let arrow = Image("arrow")
	static let download = Image("download")

	static let rewindBack = Image("rewind.back")
	static let rewindForward = Image("rewind.forward")

	static private let chevronDown = Image("chevron")
	static func chevron(_ direction: ChevronDirection) -> some View {
		chevronDown
			.rotationEffect(.degrees(Double(direction.rawValue) * 90.0))
	}
}
