//
//  AudioVisualizerItem.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import SwiftUI

struct AudioVisualizerItem: Identifiable {
	static let itemSet: [AudioVisualizerItem] = [
		.init(image: .init(.visualizer1), isRotatable: true),
		.init(image: .init(.visualizer2), isRotatable: true),
		.init(image: .init(.visualizer3), isRotatable: false),
		.init(image: .init(.visualizer4), isRotatable: false),
		.init(image: .init(.visualizer5), isRotatable: false),
		.init(image: .init(.visualizer6), isRotatable: true),
		.init(image: .init(.visualizer7), isRotatable: true),
		.init(image: .init(.visualizer8), isRotatable: true),
		.init(image: .init(.visualizer9), isRotatable: true),
		.init(image: .init(.visualizer10), isRotatable: true),
		.init(image: .init(.visualizer11), isRotatable: true),
		.init(image: .init(.visualizer12), isRotatable: true),
		.init(image: .init(.visualizer13), isRotatable: true),
		.init(image: .init(.visualizer14), isRotatable: true),
		.init(image: .init(.visualizer15), isRotatable: true)
	]

	var id = UUID()

	var image: Image
	var isRotatable: Bool

	var point: CGPoint = .zero
	var velocity: CGPoint = .zero
	var acceleration: CGPoint = .zero

	var rotation: CGFloat = .zero
	var rotationSpeed: CGFloat = .zero
}
