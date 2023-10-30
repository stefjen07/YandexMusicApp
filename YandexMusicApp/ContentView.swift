//
//  ContentView.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct ContentView: View {
	@State var isDropdownMenuOpened = false

    var body: some View {
		VStack(spacing: 21) {
			HStack {
				ForEach(InstrumentType.allCases) { instrument in
					InstrumentButton(instrument)

					if instrument != InstrumentType.allCases.last {
						Spacer()
					}
				}
			}

			ZStack {


				VStack(spacing: 7) {
					Spacer()

					if isDropdownMenuOpened {
						ForEach(0..<5) { _ in
							TrackView(.init(name: "Ударные 1"))
						}
					}
				}
			}

			HStack {
				DropdownMenuButton(isOpened: $isDropdownMenuOpened)

				Spacer()

				SquareButton(Icons.microphone) {

				}
				SquareButton(Icons.record) {

				}
				SquareButton(Icons.play) {

				}
			}
        }
		.padding(15)
		.background(.black)
    }
}

#Preview {
    ContentView()
}
