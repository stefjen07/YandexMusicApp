//
//  OutputFileType.swift
//  YandexMusicApp
//
//  Created by Евгений on 5.11.23.
//

import Foundation
import UniformTypeIdentifiers

enum OutputFileType: String, CaseIterable {
	static private let currentFileTypeKey = "outputFileType"
	static var current: OutputFileType {
		get {
			if let rawValue = UserDefaults.standard.string(forKey: currentFileTypeKey) {
				return OutputFileType(rawValue: rawValue) ?? .wav
			}

			return .wav
		}
		set {
			UserDefaults.standard.setValue(newValue.rawValue, forKey: currentFileTypeKey)
		}
	}

	case wav
	case aiff
	case mpeg4

	var utType: UTType {
		switch self {
		case .wav:
			.wav
		case .aiff:
			.aiff
		case .mpeg4:
			.mpeg4Audio
		}
	}

	var name: String {
		switch self {
		case .wav:
			"WAV"
		case .aiff:
			"AIFF"
		case .mpeg4:
			"M4A"
		}
	}

	var next: OutputFileType {
		let index = ((OutputFileType.allCases.firstIndex(of: self) ?? -1) + 1) % OutputFileType.allCases.count
		return OutputFileType.allCases[index]
	}
}
