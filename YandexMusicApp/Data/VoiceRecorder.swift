//
//  VoiceRecorder.swift
//  YandexMusicApp
//
//  Created by Евгений on 1.11.23.
//

import Foundation
import AVFoundation

class VoiceRecorder: NSObject, ObservableObject {
	@Published var isRecording = false
	@Published var isAllowed = false

	private var recordingSession: AVAudioSession
	private var recorder: AVAudioRecorder?

	private var recordingHandler: (() -> Void)?

	override init() {
		self.recordingSession = AVAudioSession.sharedInstance()
		super.init()

		do {
			try recordingSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.interruptSpokenAudioAndMixWithOthers, .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay, .defaultToSpeaker])
			try recordingSession.setActive(true)
		} catch {
			print(error)
		}

		recordingSession.requestRecordPermission() { isAllowed in
			DispatchQueue.main.async { [unowned self] in
				self.isAllowed = isAllowed
			}
		}
	}

	private func getAudioUrl(_ id: Int) -> URL? {
		URL.documentsDirectory?.appendingPathComponent("voice\(id)", conformingTo: .wav)
	}

	func startRecording(_ id: Int, completionHandler: @escaping () -> Void) {
		guard let audioUrl = getAudioUrl(id),
			  let format = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 2, interleaved: false)
		else { return }

		self.recordingHandler = completionHandler

		DispatchQueue.main.async { [unowned self] in
			do {
				let recorder = try AVAudioRecorder(url: audioUrl, format: format)
				self.recorder = recorder
				recorder.delegate = self
				recorder.record()
				isRecording = true
			} catch {
				print(error)
			}
		}
	}

	func stopRecording() {
		recorder?.stop()
	}
}

extension VoiceRecorder: AVAudioRecorderDelegate {
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		DispatchQueue.main.async { [unowned self] in
			isRecording = false
			recordingHandler?()
		}
	}
}
