//
//  NavigationBarButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import SwiftUI

struct NavigationBarButton: View {
	var icon: Image
	var color: Color
	var action: () -> Void

	var body: some View {
		Button(action: action, label: {
			icon
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 13)
				.frame(width: 34, height: 34)
				.background(color)
				.cornerRadius(4)
		})
	}
}

#Preview {
	NavigationBarButton(icon: Icons.arrow, color: Colors.padBackground, action: {
		
	})
}
