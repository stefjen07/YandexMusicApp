//
//  DropdownMenuButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct DropdownMenuButton: View {
	@Binding var isOpened: Bool

	var body: some View {
		Button(action: {
			isOpened.toggle()
		}, label: {
			HStack(spacing: 16) {
				Text("Слои")
					.foregroundStyle(.black)
				Icons.chevron(isOpened ? .down : .up)
			}
				.padding(10)
				.background(isOpened ? Colors.selection : .white)
				.cornerRadius(4)
		})
	}
}

#Preview {
	DropdownMenuButton(isOpened: .constant(true))
}
