//
//  Slider.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.12.23.
//

import SwiftUI

struct Slider: UIViewRepresentable {
	@Binding var currentValue: Double
	let maximumValue: Double
	var onValueChanged: ((Double) -> Void)?

	private let thumbImage: UIImage
	private let minimumColor: UIColor?
	private let maximumColor: UIColor?

	final class Coordinator: NSObject {
		var value: Binding<Double>
		var onValueChanged: ((Double) -> Void)?

		init(value: Binding<Double>, onValueChanged: ((Double) -> Void)? = nil) {
			self.value = value
			self.onValueChanged = onValueChanged
		}

		@objc func valueChanged(_ sender: UISlider) {
			self.value.wrappedValue = Double(sender.value)
			guard let onValueChanged = onValueChanged else {
				return
			}
			onValueChanged(Double(sender.value))
		}
	}

	init(_ currentValue: Binding<Double>,
		 maximumValue: Double,
		 onValueChanged: ((Double) -> Void)? = nil,
		 thumbRadius: CGFloat = 15,
		 thumbColor: UIColor = .white,
		 minimumColor: UIColor? = Colors.minimumTrack,
		 maximumColor: UIColor? = Colors.maximumTrack) {
		let thumb = UIView()
		thumb.backgroundColor = thumbColor
		thumb.layer.borderWidth = 0.4
		thumb.layer.borderColor = UIColor.darkGray.cgColor
		thumb.frame = CGRect(x: 0, y: thumbRadius / 2, width: thumbRadius, height: thumbRadius)
		thumb.layer.cornerRadius = thumbRadius / 2

		let renderer = UIGraphicsImageRenderer(bounds: thumb.bounds)
		self.thumbImage = renderer.image { rendererContext in
			thumb.layer.render(in: rendererContext.cgContext)
		}
		self.minimumColor = minimumColor
		self.maximumColor = maximumColor

		self.onValueChanged = onValueChanged
		self._currentValue = currentValue
		self.maximumValue = maximumValue.isNormal ? maximumValue : 0
	}

	func makeUIView(context: Context) -> UISlider {
		let slider = UISlider()
		slider.setThumbImage(thumbImage, for: .normal)
		slider.minimumTrackTintColor = minimumColor
		slider.maximumTrackTintColor = maximumColor

		slider.value = Float(currentValue)
		slider.maximumValue = Float(maximumValue)
		slider.addTarget(
			context.coordinator,
			action: #selector(Coordinator.valueChanged(_:)),
			for: .valueChanged
		)

		return slider
	}
	
	func updateUIView(_ slider: UISlider, context: Context) {
		slider.setValue(Float(currentValue), animated: true)
		slider.maximumValue = Float(maximumValue)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(value: $currentValue, onValueChanged: onValueChanged)
	}

	typealias UIViewType = UISlider


}

#Preview {
	Slider(.constant(5), maximumValue: 10)
}
