//
//  ContextMenu.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public class ContextMenu: NSObject, ContextMenuInteraction {
    
    public typealias Provider = (inout ContextMenuBuildable)->()
    public typealias PreviewProvider = ([String: Any])->UIViewController?
    public typealias PreviewCommitter = ([String: Any], UIViewController?)->()
    public typealias TargetedPreviewProvider = ([String: Any])->UITargetedPreview?
    
    private var title: String?
    private var identifier: String?
    private var configurationIdentifier: NSCopying?
    private var options: UIMenu.Options = []
    private var elements: [UIMenuElement] = []
    private var previewProvider: ContextMenu.PreviewProvider?
    private var previewCommitter: ContextMenu.PreviewCommitter?
    private var previewCommitStyle: UIContextMenuInteractionCommitStyle = .pop
    private var targetedHighlightPreviewProvider: ContextMenu.TargetedPreviewProvider?
    private var targetedDismissPreviewProvider: ContextMenu.TargetedPreviewProvider?
    private var includeSuggestedElements: Bool = false
    private var willPresent: (()->())?
    private var willDismiss: (()->())?
    
    @available(iOS 16, *)
    private var elementSize: UIMenu.ElementSize {
        get {
            return (self._elementSize as? UIMenu.ElementSize) ?? .large
        }
        set {
            self._elementSize = newValue
        }
    }
    
    private var _elementSize: Any?
    
    private var provider: Provider
    internal weak var interaction: UIContextMenuInteraction?
    private(set) var data = [String: Any]()
    
    public init(provider: @escaping Provider) {

        self.provider = provider
        
        super.init()

        var buildable: ContextMenuBuildable = ContextMenuBuilder()
        self.provider(&buildable)
        update(using: buildable)

    }
    
    private func update(using buildable: ContextMenuBuildable) {
        
        self.title = buildable.title
        self.identifier = buildable.identifier
        self.configurationIdentifier = buildable.configurationIdentifier
        self.options = buildable.options
        self.elements = buildable.elements
        self.previewProvider = buildable.previewProvider
        self.previewCommitter = buildable.previewCommitter
        self.previewCommitStyle = buildable.previewCommitStyle
        self.targetedHighlightPreviewProvider = buildable.targetedHighlightPreviewProvider
        self.targetedDismissPreviewProvider = buildable.targetedDismissPreviewProvider
        self.includeSuggestedElements = buildable.includeSuggestedElements
        self.willPresent = buildable.willPresent
        self.willDismiss = buildable.willDismiss
        
        if #available(iOS 16, *) {
            self.elementSize = buildable.elementSize
        }
        
    }
    
    private func configuration() -> UIContextMenuConfiguration {
        
        // Ask our provider for an updated layout
        
        var buildable: ContextMenuBuildable = ContextMenuBuilder()
        self.provider(&buildable)
        update(using: buildable)
        
        // Build configuration
        
        var previewProvider: UIContextMenuContentPreviewProvider?
        var actionProvider: UIContextMenuActionProvider?

        if let preview = self.previewProvider {

            previewProvider = {
                return preview(self.data)
            }

        }

        if !self.elements.isEmpty {

            // Only assign an action provider if we have elements.
            // If we don't have elements, we only want to show
            // a preview (if provided).

            actionProvider = { suggestedElements in

                var additionalElements = [UIMenuElement]()

                if self.includeSuggestedElements {
                    additionalElements.append(contentsOf: suggestedElements)
                }

                return self.menu(additionalElements: additionalElements)

            }

        }
        
        return UIContextMenuConfiguration(
            identifier: self.configurationIdentifier,
            previewProvider: previewProvider,
            actionProvider: actionProvider
        )
        
    }
    
    private func menu(additionalElements: [UIMenuElement]) -> UIMenu {
        
        var elements = self.elements
        elements.append(contentsOf: additionalElements)
        
        let menu = UIMenu(
            title: self.title ?? "",
            identifier: (self.identifier != nil) ? UIMenu.Identifier(self.identifier!) : nil,
            options: self.options,
            children: elements
        )

        if #available(iOS 16, *) {
            menu.preferredElementSize = self.elementSize
        }
                
        return menu

    }
    
}

extension ContextMenu: UIContextMenuInteractionDelegate {
    
    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                       configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

        return configuration()

    }

    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                       willDisplayMenuFor configuration: UIContextMenuConfiguration,
                                       animator: UIContextMenuInteractionAnimating?) {

        self.willPresent?()

    }

    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                       willEndFor configuration: UIContextMenuConfiguration,
                                       animator: UIContextMenuInteractionAnimating?) {

        self.willDismiss?()

    }

    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                       previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        return self.targetedHighlightPreviewProvider?(self.data)

    }

    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                       previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {

        return self.targetedDismissPreviewProvider?(self.data)

    }

    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                       willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                       animator: UIContextMenuInteractionCommitAnimating) {

        // If this protocol function is implemented,
        // the system always performs some kind of animation.
        // This isn't ideal, but doesn't hurt anything.
        //
        // Need to find a way to conditionally adopt this function
        // Only when needed.
        //
        // responds(toSelector:) fuckery?

        guard let committer = self.previewCommitter else { return }

        animator.preferredCommitStyle = self.previewCommitStyle

        animator.addCompletion {

            committer(
                self.data,
                animator.previewViewController
            )

        }

    }
    
}
