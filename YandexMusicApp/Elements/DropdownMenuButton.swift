//
//  DropdownMenuButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct DropdownMenuButton: View {
	var title: any StringProtocol
	@Binding var isOpened: Bool

	init(_ title: any StringProtocol, isOpened: Binding<Bool>) {
		self.title = title
		self._isOpened = isOpened
	}

	var body: some View {
		Button(action: {
			isOpened.toggle()
		}, label: {
			HStack(spacing: 16) {
				Text(title)
					.font(.ysTextBody)
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
	DropdownMenuButton("Слои", isOpened: .constant(true))
}
