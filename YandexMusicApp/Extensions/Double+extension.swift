//
//  Double+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import Foundation

extension Double {
	var timeFormatted: String {
		let time = isNormal ? self : 0
		let minutes = Int(time) / 60
		let seconds = Int(time) % 60
		return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
	}
}
