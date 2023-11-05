//
//  TrackStorage.swift
//  YandexMusicApp
//
//  Created by Евгений on 4.11.23.
//

import Foundation
import CoreData

protocol TrackStoraging {
	var tracks: [Track] { get set }
}

class TrackStorage: TrackStoraging {
	private let persistentContainer = NSPersistentContainer(name: "Model")

	init() {
		persistentContainer.loadPersistentStores { description, error in
			if let error {
				print(error)
			}
		}
	}

	var tracks: [Track] {
		get {
			let viewContext = persistentContainer.viewContext

			do {
				return try viewContext.fetch(TrackModel.fetchRequest()).map { .init($0) }
			} catch {
				print(error)
			}

			return []
		}
		set {
			let viewContext = persistentContainer.viewContext

			do {
				let dbTracks = try viewContext.fetch(TrackModel.fetchRequest()).filter { dbTrack in
					if !newValue.contains(where: { $0.id.uuidString == dbTrack.id?.uuidString }) {
						viewContext.delete(dbTrack)
						return false
					}

					return true
				}

				newValue.forEach { track in
					let dbModel = dbTracks.first {
						track.id.uuidString == $0.id?.uuidString
					} ?? TrackModel(context: viewContext)
					track.copyToDB(dbModel)
				}

				try viewContext.save()
			} catch {
				viewContext.rollback()
				print(error)
			}
		}
	}
}
