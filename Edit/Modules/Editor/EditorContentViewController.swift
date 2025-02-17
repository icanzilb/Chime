import AppKit
import SwiftUI

import Theme
import UIUtility

/// Defines the overall editor scene.
///
/// This controller establishes the larger editor scene, typing together the sub components.
public final class EditorContentViewController: NSViewController {
	let editorScrollView = NSScrollView()
	let sourceViewController = SourceViewController()

	public init() {
		super.init(nibName: nil, bundle: nil)

		addChild(sourceViewController)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func loadView() {
		editorScrollView.hasVerticalScroller = true
		editorScrollView.hasHorizontalScroller = true
		editorScrollView.drawsBackground = true
		editorScrollView.backgroundColor = .black

		// allow the scroll view to use the entire height of a full-content windows
		editorScrollView.automaticallyAdjustsContentInsets = false

		let presentationController = SourcePresentationViewController(scrollView: editorScrollView)

		presentationController.gutterView = NSHostingView(rootView: Color.yellow.ignoresSafeArea())
//		presentationController.underlayView = NSHostingView(rootView: Color.red)
//		presentationController.overlayView = NSHostingView(rootView: Color.blue)
		presentationController.documentView = sourceViewController.view

		// For debugging. Just be careful, because the SourceView/ScrollView relationship is extremely complex.
//		presentationController.documentView = NSHostingView(rootView: BoundingBorders())
//		presentationController.documentView?.translatesAutoresizingMaskIntoConstraints = false

		let hostedView = EditorContent {
			RepresentableViewController(presentationController)
		   } themeUpdateAction: { [sourceViewController] in
			   sourceViewController.updateTheme($0, context: $1)
		   }

		self.view = NSHostingView(rootView: hostedView)
	}
}
