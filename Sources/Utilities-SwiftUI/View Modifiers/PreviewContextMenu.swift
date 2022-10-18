//
//  PreviewContextMenu.swift
//  CleanKitchen
//
//  Created by Evan Coleman on 3/20/22.
//

#if os(iOS)
import SwiftUI

import Introspect

struct PreviewContextMenuModifier<Preview: View>: ViewModifier {

    var preview: Preview
    var menuItems: [UIAction]
    var action: () -> Void

    @State private var previewView: UIView?

    func body(content: Content) -> some View {
        content
            .introspectViewController { viewController in
                previewView = viewController.view
            }
            .introspectTableViewCell { cell in
                previewView = cell
            }
            .overlay(
                PreviewContextMenuView(
                    preview: preview,
                    previewView: previewView,
                    menu: UIMenu(title: "", children: menuItems),
                    didTapPreview: action
                )
            )
    }
}

extension View {
    public func contextMenu<Preview: View>(action: @escaping () -> Void, menuItems: [UIAction], preview: () -> Preview) -> some View {
        return modifier(PreviewContextMenuModifier(preview: preview(), menuItems: menuItems, action: action))
    }
}

private struct PreviewContextMenuView<Preview: View>: UIViewRepresentable {

    var preview: Preview
    var previewView: UIView?
    var menu: UIMenu
    var didTapPreview: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let menuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(menuInteraction)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.previewView = previewView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            preview: preview,
            previewView: previewView,
            menu: menu,
            didTapPreview: didTapPreview
        )
    }

    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        let preview: Preview
        var previewView: UIView?
        let menu: UIMenu
        let didTapPreview: () -> Void

        private var targetedPreview: UITargetedPreview? {
            guard let previewView = previewView else { return nil }

            let parameters = UIPreviewParameters()
            parameters.backgroundColor = .clear

            return UITargetedPreview(view: previewView, parameters: parameters)
        }

        init(preview: Preview, previewView: UIView?, menu: UIMenu, didTapPreview: @escaping () -> Void) {
            self.preview = preview
            self.previewView = previewView
            self.menu = menu
            self.didTapPreview = didTapPreview
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

            return UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: { [weak self] () -> UIViewController? in
                    guard let self = self else { return nil }

                    return PreviewHostingController(rootView: self.preview)
                },
                actionProvider: { [weak self] _ in
                    return self?.menu
                }
            )
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            animator.addCompletion(self.didTapPreview)
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

            return targetedPreview
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

            return targetedPreview
        }
    }
}

private final class PreviewHostingController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let window = view.window {
            preferredContentSize.width = window.frame.size.width - 32
        }

        let targetSize = view.intrinsicContentSize
        preferredContentSize.height = targetSize.height
    }
}
#endif
