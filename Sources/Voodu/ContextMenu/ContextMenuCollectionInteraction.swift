//
//  ContextMenuCollectionInteraction.swift
//  Voodu
//
//  Created by Mitch Treece on 8/10/22.
//

import UIKit

/// Context menu collection-interaction object.
public struct ContextMenuCollectionInteraction {
    
    internal let contextMenu: ContextMenu
    
    internal init(contextMenu: ContextMenu) {
        self.contextMenu = contextMenu
    }
        
    // MARK: Data
    
    /// Sets a piece data for a given key.
    ///
    /// - parameter data: The data.
    /// - parameter key: The key to associate the data to.
    /// - returns: This context menu collection-interaction.
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
    
    /// Requests a context menu configuration from the interaction.
    ///
    /// - parameter collectionView: The collection view requesting the configuration.
    /// - parameter indexPath: The index path the configuration is being requested for.
    /// - parameter point: The interaction point in the collection view.
    /// - returns: A context menu configuration for a given index path.
    ///
    /// Calling this automatically adds the index path & cell to the interaction's
    /// (and underlying context menu's) data container.
    ///
    ///     let indexPath: IndexPath = data.indexPath()
    ///     let cell: UICollectionViewCell = data.collectionCell()
    public func configuration(in collectionView: UICollectionView,
                              indexPath: IndexPath,
                              point: CGPoint) -> UIContextMenuConfiguration {
        
        self.contextMenu.setData(
            indexPath,
            forKey: ContextMenuData.indexPathKey
        )
        
        self.contextMenu.setData(
            collectionView.cellForItem(at: indexPath),
            forKey: ContextMenuData.collectionCellKey
        )

        return self.contextMenu
            .configuration()
        
    }
    
    /// Tells the interaction that a context menu is about to be presented.
    ///
    /// - parameter collectionView: The collection view presenting the context menu.
    /// - parameter configuration: The context menu configuration that is being presented.
    /// - parameter animator: The context menu interaction animator.
    public func willDisplay(in collectionView: UICollectionView,
                            configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu
            .willPresent?()
        
    }
    
    /// Tells the interaction that a context menu is about to be dismissed.
    ///
    /// - parameter collectionView: The collection view dismissing the context menu.
    /// - parameter configuration: The context menu configuration that is being dismissed.
    /// - parameter animator: The context menu interaction animator.
    public func willEnd(in collectionView: UICollectionView,
                        configuration: UIContextMenuConfiguration,
                        animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu
            .willDismiss?()
        
    }
    
    /// Requests a context menu highlight preview from the interaction.
    ///
    /// - parameter collectionView: The collection view presenting the context menu.
    /// - parameter configuration: The context menu configuration that is being presented.
    /// - returns: A context menu highlight preview.
    public func highlightPreview(in collectionView: UICollectionView,
                                 configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return self.contextMenu
            .targetedHighlightPreviewProvider?()
        
    }
    
    /// Requests a context menu dismiss preview from the interaction.
    ///
    /// - parameter collectionView: The collection view dismissing the context menu.
    /// - parameter configuration: The context menu configuration that is being dismissed.
    /// - returns: A context menu dismiss preview.
    public func dismissPreview(in collectionView: UICollectionView,
                               configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        self.contextMenu
            .targetedDismissPreviewProvider?()
        
    }
    
    /// Tells the interaction that a context menu preview action is about to be performed.
    ///
    /// - parameter collectionView: The collection view presenting the context menu.
    /// - parameter configuration: The context menu configuration that is being presented.
    /// - parameter animator: The context menu interaction commit animator.
    public func willPerformPreviewAction(in collectionView: UICollectionView,
                                         configuration: UIContextMenuConfiguration,
                                         animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let action = self.contextMenu.previewCommitAction else { return }

        animator.preferredCommitStyle = self.contextMenu.previewCommitStyle

        animator.addCompletion {
            action(animator.previewViewController)
        }
        
    }
    
}
