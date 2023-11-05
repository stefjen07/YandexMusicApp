//
//  TrackWaveGenerator.swift
//  YandexMusicApp
//
//  Created by Евгений on 3.11.23.
//

import Foundation
import AVFoundation
import Accelerate

protocol TrackWaveGeneratorProtocol {
	func processAudioData(buffer: AVAudioPCMBuffer) -> CGFloat?
}

class TrackWaveGenerator: TrackWaveGeneratorProtocol {
	private func rms(data: UnsafeMutablePointer<Float>, frameLength: UInt) -> Float {
		var value: Float = 0
		vDSP_measqv(data, 1, &value, frameLength)
		value *= 1000
		return value
	}

	private func normalizeSoundLevel(_ level: Float) -> CGFloat {
		return max(0.2, CGFloat(level) + 70) / 2
	}

	func processAudioData(buffer: AVAudioPCMBuffer) -> CGFloat? {
		guard let channelData = buffer.floatChannelData?[0] else { return nil }

		let level = 10 * log10f(rms(data: channelData, frameLength: UInt(buffer.frameLength)))
		return normalizeSoundLevel(level)
	}
}
