//
//  ContextMenuCollectionInteraction.swift
//  Voodu
//
//  Created by Mitch Treece on 8/10/22.
//

import UIKit

public struct ContextMenuCollectionInteraction {
    
    internal let contextMenu: ContextMenu
    
    internal init(contextMenu: ContextMenu) {
        self.contextMenu = contextMenu
    }
        
    // MARK: Data
    
    @discardableResult
    public func setData(_ data: Any?,
                        forKey key: String) -> Self {
        
        self.contextMenu.data.set(
            data,
            forKey: key
        )
        
        return self
        
    }

    // MARK: UICollectionView
    
    public func configuration(in collectionView: UICollectionView,
                              indexPath: IndexPath,
                              point: CGPoint) -> UIContextMenuConfiguration {
        
        self.contextMenu.data.set(
            indexPath,
            forKey: "indexPath"
        )
        self.contextMenu.data["cell"] = collectionView.cellForItem(at: indexPath)

        return self.contextMenu
            .configuration()
        
    }
    
    public func willDisplay(in collectionView: UICollectionView,
                            configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu
            .willPresent?()
        
    }
    
    public func willEnd(in collectionView: UICollectionView,
                        configuration: UIContextMenuConfiguration,
                        animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu
            .willDismiss?()
        
    }
    
    public func highlightingPreview(in collectionView: UICollectionView,
                                    configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return self.contextMenu
            .targetedHighlightPreviewProvider?()
        
    }
    
    public func dismissingPreview(in collectionView: UICollectionView,
                                  configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        self.contextMenu
            .targetedDismissPreviewProvider?()
        
    }
    
    public func willPerformPreviewAction(in collectionView: UICollectionView,
                                         configuration: UIContextMenuConfiguration,
                                         animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let committer = self.contextMenu.previewCommitter else { return }

        animator.preferredCommitStyle = self.contextMenu.previewCommitStyle

        animator.addCompletion {
            committer(animator.previewViewController)
        }
        
    }
    
}
