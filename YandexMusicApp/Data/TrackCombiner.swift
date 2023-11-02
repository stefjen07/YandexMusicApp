//
//  TrackCombiner.swift
//  YandexMusicApp
//
//  Created by Евгений on 1.11.23.
//

import Foundation
import AVFoundation

protocol TrackCombinerProtocol {
	func playCombinedTracks(_ tracks: [Track])
	func playAndRecordCombinedTracks(_ tracks: [Track], completionHandler: @escaping (URL) -> Void)
	func stopCombinedTracks()
}

class TrackCombiner: TrackCombinerProtocol {
	private var engine = AVAudioEngine()

	private var writingHandler: ((URL) -> Void)?

	private let sampleRepository: SampleRepositoryProtocol = SampleRepository()

	private func getDocumentsDirectory() -> URL? {
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls.first
	}

	private func combineTracks(_ tracks: [Track]) {
		engine = AVAudioEngine()

		for track in tracks {
			do {
				var url: URL?

				switch track.type {
				case .instrument(let instrumentType, let sample):
					url = sampleRepository.getSample(instrumentType, sample: sample)
				case .voice:
					url = getDocumentsDirectory()?.appendingPathComponent("voice\(track.number)", conformingTo: .wav)
				}

				if let url {
					let playerNode = AVAudioPlayerNode()
					let file = try AVAudioFile(forReading: url)

					if let fileBuffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length)) {
						try file.read(into: fileBuffer)

						let changeAudioUnitTime = AVAudioUnitTimePitch()
						changeAudioUnitTime.rate = Float(track.speed)

						engine.attach(playerNode)
						engine.attach(changeAudioUnitTime)

						engine.connect(playerNode, to: changeAudioUnitTime, format: file.processingFormat)
						engine.connect(changeAudioUnitTime, to: engine.mainMixerNode, format: nil)

						playerNode.scheduleBuffer(fileBuffer, at: nil, options: .loops, completionHandler: nil)
						playerNode.volume = Float(track.volume)
					}
				}
			} catch {
				print(error)
			}
		}
	}

	private var destinationUrl: URL? {
		getDocumentsDirectory()?.appendingPathComponent("composition", conformingTo: .aiff)
	}

	func playCombinedTracks(_ tracks: [Track]) {
		combineTracks(tracks)

		guard !engine.attachedNodes.isEmpty else { return }

		do {
			engine.prepare()
			try engine.start()

			for attachedNode in engine.attachedNodes {
				if let playerNode = attachedNode as? AVAudioPlayerNode {
					playerNode.play()
				}
			}
		} catch {
			print(error)
		}
	}

	func playAndRecordCombinedTracks(_ tracks: [Track], completionHandler: @escaping (URL) -> Void) {
		combineTracks(tracks)

		guard !engine.attachedNodes.isEmpty else { return }

		writingHandler = completionHandler

		let recordingFormat = engine.mainMixerNode.outputFormat(forBus: 0)

		if let destinationUrl,
		   let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: recordingFormat.sampleRate, channels: 1, interleaved: false)
		{
			if FileManager.default.fileExists(atPath: destinationUrl.absoluteString) {
				try? FileManager.default.removeItem(atPath: destinationUrl.absoluteString)
			}

			do {
				let file = try AVAudioFile(
					forWriting: destinationUrl,
					settings: outputFormat.settings,
					commonFormat: outputFormat.commonFormat,
					interleaved: outputFormat.isInterleaved
				)

				print(AVAudioSession.sharedInstance().sampleRate, recordingFormat.sampleRate)



				if let audioConverter = AVAudioConverter(from: recordingFormat, to: outputFormat) {
					audioConverter.channelMap = [0]
					engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, time in
						do {
							if let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: buffer.frameCapacity) {
								try audioConverter.convert(to: convertedBuffer, from: buffer)
								try file.write(from: convertedBuffer)
							}
						} catch {
							print(error)
						}
					}
				}
			} catch {
				print(error)
			}
		}



		do {
			engine.prepare()
			try engine.start()

			for attachedNode in engine.attachedNodes {
				if let playerNode = attachedNode as? AVAudioPlayerNode {
					playerNode.play()
				}
			}
		} catch {
			print(error)
		}
	}

	func stopCombinedTracks() {
		engine.mainMixerNode.removeTap(onBus: 0)
		engine.stop()

		DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .microseconds(100))) { [unowned self] in
			if let destinationUrl {
				writingHandler?(destinationUrl)
				writingHandler = nil
			}
		}
	}
}
