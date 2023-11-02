//
//  AVAudioPCMBuffer+extension.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.11.23.
//

import AVFoundation

extension AVAudioPCMBuffer {
	var data: Data {
		let channelCount = 1
		let channels = UnsafeBufferPointer(start: self.floatChannelData, count: channelCount)
		let ch0Data = NSData(bytes: channels[0], length:Int(self.frameCapacity * self.format.streamDescription.pointee.mBytesPerFrame))
		return ch0Data as Data
	}
}
