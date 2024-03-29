//
//  PreviewContextView.swift
//  Utilities
//
//  Created by Evan Coleman on 1/26/22.
//

#if os(iOS)
import SwiftUI

public struct PreviewContextMenu<Content: View> {
    public let destination: Content
    public let actionProvider: UIContextMenuActionProvider?

    public init(destination: Content, actionProvider: UIContextMenuActionProvider? = nil) {
        self.destination = destination
        self.actionProvider = actionProvider
    }
}

struct PreviewContextView<Content: View>: UIViewRepresentable {

    let menu: PreviewContextMenu<Content>
    let didCommitView: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let menuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(menuInteraction)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        return Coordinator(menu: self.menu, didCommitView: self.didCommitView)
    }

    class Coordinator: NSObject, UIContextMenuInteractionDelegate {

        let menu: PreviewContextMenu<Content>
        let didCommitView: () -> Void

        init(menu: PreviewContextMenu<Content>, didCommitView: @escaping () -> Void) {
            self.menu = menu
            self.didCommitView = didCommitView
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
                UIHostingController(rootView: self.menu.destination)
            }, actionProvider: self.menu.actionProvider)
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            animator.addCompletion(self.didCommitView)
        }

    }
}

extension View {
    public func contextMenu<Content: View>(_ menu: PreviewContextMenu<Content>) -> some View {
        self.modifier(PreviewContextViewModifier(menu: menu))
    }
}

struct PreviewContextViewModifier<V: View>: ViewModifier {

    let menu: PreviewContextMenu<V>
    @Environment(\.presentationMode) var mode

    @State var isActive: Bool = false

    func body(content: Content) -> some View {
        Group {
            if isActive {
                menu.destination
            } else {
                content.overlay(PreviewContextView(menu: menu, didCommitView: { self.isActive = true }))
            }
        }
    }
}
#endif
