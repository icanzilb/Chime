import SwiftUI

public struct RepresentableViewController<Controller: NSViewController>: NSViewControllerRepresentable {
	public let controller: Controller

	public init(_ controller: Controller) {
		self.controller = controller
	}

	public func makeNSViewController(context: Context) -> some NSViewController {
		return controller
	}

	public func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
	}
}

extension RepresentableViewController {
	/// Provide a intermediary SwiftUI view for APIs that use `NSViewController`.
	@MainActor
	public static func wrap<Content: View>(controller: Controller, block: (Self) -> Content) -> NSHostingController<Content> {
		let represented = RepresentableViewController(controller)

		let content = block(represented)

		return NSHostingController(rootView: content)
	}
}
