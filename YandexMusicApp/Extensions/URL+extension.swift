//
//  URL+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.11.23.
//

import Foundation

extension URL: Identifiable {
	public var id: Int {
		absoluteString.hashValue
	}
}

extension URL {
	static var documentsDirectory: URL? {
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls.first
	}
}
