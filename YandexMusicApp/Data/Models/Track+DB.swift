//
//  Track+DB.swift
//  YandexMusicApp
//
//  Created by Евгений on 4.11.23.
//

import Foundation
import CoreData

extension Track {
	convenience init(_ dbModel: TrackModel) {
		var type: TrackType

		if dbModel.sample == -1 {
			type = .voice
		} else  {
			type = .instrument(.init(id: Int(dbModel.instrument)), sample: Int(dbModel.sample))
		}

		self.init(
			id: dbModel.id ?? .init(),
			type: type,
			number: Int(dbModel.number),
			speed: dbModel.speed,
			volume: dbModel.volume,
			isMuted: dbModel.isMuted
		)
	}

	func copyToDB(_ dbTrack: TrackModel) {
		dbTrack.id = id
		dbTrack.isMuted = isMuted
		dbTrack.number = Int64(number)
		dbTrack.speed = speed
		dbTrack.volume = volume

		switch type {
		case .instrument(let instrument, let sample):
			dbTrack.instrument = Int64(instrument.id)
			dbTrack.sample = Int64(sample)
		case .voice:
			dbTrack.instrument = 0
			dbTrack.sample = -1
		}
	}
}
