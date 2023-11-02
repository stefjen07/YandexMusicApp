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

	private var recordingHandler: ((Track?) -> Void)?

	override init() {
		self.recordingSession = AVAudioSession.sharedInstance()
		super.init()

		do {
			try recordingSession.setCategory(.playAndRecord, mode: .default)
			try recordingSession.setActive(true)
			recordingSession.requestRecordPermission() { [unowned self] in
				isAllowed = $0
			}
		} catch {
			print(error)
		}
	}

	private func getDocumentsDirectory() -> URL? {
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls.first
	}

	func startRecording(_ id: Int, completionHandler: @escaping (Track?) -> Void) {
		guard let audioUrl = getDocumentsDirectory()?.appendingPathComponent("voice\(id)", conformingTo: .wav) else {
			return
		}

		let settings: [String : Any] = [
			AVFormatIDKey: Int(kAudioFormatLinearPCM),
			AVSampleRateKey: 44100.0,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue 
		]

		self.recordingHandler = completionHandler

		do {
			let recorder = try AVAudioRecorder(url: audioUrl, settings: settings)
			self.recorder = recorder
			recorder.delegate = self
			recorder.record()
			isRecording = true
		} catch {
			print(error)
		}
	}

	func stopRecording() {
		recorder?.stop()
	}
}

extension VoiceRecorder: AVAudioRecorderDelegate {
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		isRecording = false
		recordingHandler?(nil) //TODO: Implement
	}
}
