//
//  MPVolumeView+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 5.11.23.
//

import MediaPlayer

extension MPVolumeView {
	static func setVolume(_ volume: Float) {
		let volumeView = MPVolumeView()
		let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
			slider?.value = volume
		}
	}

	static func setSuitableVolume() {
		setVolume(max(0.25, AVAudioSession.sharedInstance().outputVolume))
	}
}
