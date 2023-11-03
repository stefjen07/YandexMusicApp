//
//  DocumentInteractionView.swift
//  YandexMusicApp
//
//  Created by Евгений on 2.11.23.
//

import SwiftUI
import UIKit

struct DocumentInteractionView: UIViewControllerRepresentable {
	private var url: Binding<URL?>
	private let viewController = UIViewController()
	private let docController: UIDocumentInteractionController

	init(_ url: Binding<URL?>) {
		self.url = url
		self.docController = UIDocumentInteractionController()
	}

	func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentInteractionView>) -> UIViewController {
		return viewController
	}

	func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DocumentInteractionView>) {
		if self.url.wrappedValue != nil && docController.delegate == nil {
			docController.url = url.wrappedValue
			docController.delegate = context.coordinator
			self.docController.presentPreview(animated: true)
		}
	}

	func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}

	final class Coordinator: NSObject, UIDocumentInteractionControllerDelegate {
		let parent: DocumentInteractionView

		init(parent: DocumentInteractionView) {
			self.parent = parent
		}

		func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
			return parent.viewController
		}

		func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
			controller.delegate = nil
			parent.url.wrappedValue = nil
		}
	}
}

extension View {
	func documentInteractionCover(_ url: Binding<URL?>) -> some View {
		self
			.background(
				DocumentInteractionView(url)
			)
	}
}
