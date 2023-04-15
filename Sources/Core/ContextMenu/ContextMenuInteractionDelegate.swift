//
//  ContextMenuInteractionDelegate.swift
//  Voodu
//
//  Created by Mitch Treece on 8/11/22.
//

import UIKit

internal class ContextMenuInteractionDelegate: NSObject, UIContextMenuInteractionDelegate {
    
    private weak var contextMenu: ContextMenu?
    
    init(contextMenu: ContextMenu) {
        self.contextMenu = contextMenu
    }
        
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return self.contextMenu?
            .configuration()
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willDisplayMenuFor configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu?
            .willPresent?()
        
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willEndFor configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu?
            .willDismiss?()
        
    }
    
    @available(iOS, deprecated: 16)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let contextMenu = self.contextMenu else { return nil }
        
        return contextMenu
            .targetedHighlightPreviewProvider?()
        
    }
    
    @available(iOS, deprecated: 16)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let contextMenu = self.contextMenu else { return nil }
        
        return contextMenu
            .targetedDismissPreviewProvider?()
        
    }
    
    @available(iOS 16, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configuration: UIContextMenuConfiguration,
                                highlightPreviewForItemWithIdentifier identifier: NSCopying) -> UITargetedPreview? {

        guard let contextMenu = self.contextMenu else { return nil }

        return contextMenu
            .targetedHighlightPreviewProvider?()

    }

    @available(iOS 16, *)
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configuration: UIContextMenuConfiguration,
                                dismissalPreviewForItemWithIdentifier identifier: NSCopying) -> UITargetedPreview? {

        guard let contextMenu = self.contextMenu else { return nil }

        return contextMenu
            .targetedDismissPreviewProvider?()

    }
        
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let contextMenu = self.contextMenu,
              let action = contextMenu.previewCommitAction else { return }

        animator.preferredCommitStyle = contextMenu.previewCommitStyle

        animator.addCompletion {
            action(animator.previewViewController)
        }
        
    }
    
}
