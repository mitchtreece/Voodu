//
//  ContextMenuTableInteraction.swift
//  Voodu
//
//  Created by Mitch Treece on 8/10/22.
//

import UIKit

public struct ContextMenuTableInteraction {
    
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
    
    // MARK: UITableView
    
    public func configuration(in tableView: UITableView,
                              indexPath: IndexPath,
                              point: CGPoint) -> UIContextMenuConfiguration {
        
        self.contextMenu.data["indexPath"] = indexPath
        self.contextMenu.data["cell"] = tableView.cellForRow(at: indexPath)
        
        return self.contextMenu
            .configuration()
        
    }
    
    public func willDisplay(in tableView: UITableView,
                            configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu
            .willPresent?()
        
    }
    
    public func willEnd(in tableView: UITableView,
                        configuration: UIContextMenuConfiguration,
                        animator: UIContextMenuInteractionAnimating?) {
        
        self.contextMenu
            .willDismiss?()
        
    }
    
    public func highlightPreview(in tableView: UITableView,
                                 configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return self.contextMenu
            .targetedHighlightPreviewProvider?()
        
    }
    
    public func dismissPreview(in tableView: UITableView,
                               configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        self.contextMenu
            .targetedDismissPreviewProvider?()
        
    }
    
    public func willPerformPreviewAction(in tableView: UITableView,
                                         configuration: UIContextMenuConfiguration,
                                         animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let committer = self.contextMenu.previewCommitter else { return }

        animator.preferredCommitStyle = self.contextMenu.previewCommitStyle

        animator.addCompletion {
            committer(animator.previewViewController)
        }
        
    }
    
}
