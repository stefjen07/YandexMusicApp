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
