//
//  DropdownMenuButton.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct DropdownMenuButton: View {
	let title: LocalizedStringKey
	@Binding var isOpened: Bool

	init(_ title: LocalizedStringKey, isOpened: Binding<Bool>) {
		self.title = title
		self._isOpened = isOpened
	}

	var body: some View {
		Button(action: {
			withAnimation(.easeInOut(duration: 0.35)) {
				isOpened.toggle()
			}
		}, label: {
			HStack(spacing: 16) {
				Text(title)
					.font(.ysTextBody)
					.foregroundStyle(.black)
				Icons.chevron(isOpened ? .down : .up)
			}
				.padding(10)
				.background(isOpened ? Colors.selection : Colors.buttonBackground)
				.cornerRadius(Constants.globalCornerRadius)
		})
	}
}

#Preview {
	DropdownMenuButton("layers", isOpened: .constant(true))
}
