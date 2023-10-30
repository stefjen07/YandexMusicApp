//
//  SquareButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct SquareButton: View {
	var icon: Image
	var action: () -> Void

	init(_ icon: Image, action: @escaping () -> Void) {
		self.icon = icon
		self.action = action
	}

	var body: some View {
		Button(action: action, label: {
			icon
				.frame(width: 34, height: 34)
				.background(.white)
				.cornerRadius(4)
		})
	}
}

#Preview {
	SquareButton(Icons.record) {
		
	}
}
