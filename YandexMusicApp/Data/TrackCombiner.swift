//
//  TrackCombiner.swift
//  YandexMusicApp
//
//  Created by Евгений on 1.11.23.
//

import Foundation
import AVFoundation

protocol TrackCombinerProtocol {
	var bufferHandler: ((AVAudioPCMBuffer) -> Void)? { get set }

	func playCombinedTracks(_ tracks: [Track])
	func playAndRecordCombinedTracks(_ tracks: [Track], completionHandler: @escaping (URL) -> Void)
	func stopCombinedTracks(withoutWriting: Bool)
}

class TrackCombiner: TrackCombinerProtocol {
	private var engine: AVAudioEngine = AVAudioEngine()

	var bufferHandler: ((AVAudioPCMBuffer) -> Void)?
	private var writingHandler: ((URL) -> Void)?

	private let sampleRepository: SampleRepositoryProtocol = SampleRepository()

	private func getDocumentsDirectory() -> URL? {
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return urls.first
	}

	private func combineTracks(_ tracks: [Track]) {
		engine = AVAudioEngine()

		for track in tracks {
			if !track.isMuted {
				do {
					if let url = track.getUrl(sampleRepository: sampleRepository) {
						let playerNode = AVAudioPlayerNode()
						let file = try AVAudioFile(forReading: url)

						if let fileBuffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length)) {
							try file.read(into: fileBuffer)

							let changeAudioUnitTime = AVAudioUnitTimePitch()
							changeAudioUnitTime.rate = Float(track.speed)

							engine.attach(playerNode)
							engine.attach(changeAudioUnitTime)

							engine.connect(playerNode, to: changeAudioUnitTime, format: nil)
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
	}

	private var destinationUrl: URL? {
		URL.documentsDirectory?.appendingPathComponent("composition", conformingTo: .wav)
	}

	func playCombinedTracks(_ tracks: [Track]) {
		DispatchQueue.main.async { [unowned self] in
			combineTracks(tracks)

			guard !engine.attachedNodes.isEmpty else { return }

			do {
				engine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: nil) { [unowned self] buffer, time in
					bufferHandler?(buffer)
				}

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
	}

	func playAndRecordCombinedTracks(_ tracks: [Track], completionHandler: @escaping (URL) -> Void) {
		DispatchQueue.main.async { [unowned self] in
			combineTracks(tracks)

			guard !engine.attachedNodes.isEmpty else { return }

			writingHandler = completionHandler

			let recordingFormat = engine.mainMixerNode.outputFormat(forBus: 0)

			if let destinationUrl,
			   let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: recordingFormat.sampleRate, channels: 2, interleaved: false),
			   let sessionFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: AVAudioSession.sharedInstance().sampleRate, channels: 2, interleaved: false)
			{
				if FileManager.default.fileExists(atPath: destinationUrl.absoluteString) {
					try? FileManager.default.removeItem(atPath: destinationUrl.absoluteString)
				}

				do {
					let file = try AVAudioFile(
						forWriting: destinationUrl,
						settings: sessionFormat.settings,
						commonFormat: sessionFormat.commonFormat,
						interleaved: sessionFormat.isInterleaved
					)

					if let audioConverter = AVAudioConverter(from: recordingFormat, to: outputFormat) {
						audioConverter.channelMap = [0]

						engine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: nil) { [unowned self] buffer, time in
							bufferHandler?(buffer)
							
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
	}

	func stopCombinedTracks(withoutWriting: Bool) {
		engine.mainMixerNode.removeTap(onBus: 0)
		engine.stop()

		DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .microseconds(100))) { [unowned self] in
			if let destinationUrl, !withoutWriting {
				writingHandler?(destinationUrl)
				writingHandler = nil
			}
		}
	}
}
