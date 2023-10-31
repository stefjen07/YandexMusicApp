//
//  ContentView.swift
//  YandexMusicApp
//
//  Created by Евгений on 30.10.23.
//

import SwiftUI

struct ContentView: View {
	@State var isDropdownMenuOpened = false
	@State var openedInstrument: InstrumentType?

    var body: some View {
		VStack(spacing: 21) {
			ZStack(alignment: .top) {
				HStack(alignment: .top) {
					ForEach(InstrumentType.allCases) { instrument in
						InstrumentButton(instrument, openedInstrument: $openedInstrument)

						if instrument != InstrumentType.allCases.last {
							Spacer()
						}
					}
				}

				MusicPad()
					.padding(.top, 120)
					.zIndex(-1)

				VStack(spacing: 7) {
					Spacer()

					if isDropdownMenuOpened {
						VStack {
							ForEach(0..<5) { _ in
								TrackView(.init(.insturment(.drums)))
									.shadow(color: Color.gray, radius: 5)
							}
						}
						.transition(
							.move(edge: .bottom)
								.combined(with: .opacity)
						)
					}
				}
			}

			HStack {
				DropdownMenuButton("layers", isOpened: $isDropdownMenuOpened)

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
    }
}

#Preview {
    ContentView()
}
