//
//  ContextMenuTarget.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// Protocol describing the characteristics of something
/// that can present a context menu.
public protocol ContextMenuTarget {
    
    /// The array of interactions for the target.
    var interactions: [UIInteraction] { get }
    
    /// Adds an interaction to the target.
    func addInteraction(_ interaction: UIInteraction)
    
    /// Removes an interaction from the target.
    func removeInteraction(_ interaction: UIInteraction)
    
}

extension UIView: ContextMenuTarget {}

public extension ContextMenuTarget {
        
    /// Adds a context menu to the target.
    ///
    /// - parameter contextMenu: The context menu to add.
    ///
    /// `ContextMenu` **does not** keep a strong reference to its underlying
    /// `UIContextMenuInteraction` or `UIContextMenuInteractionDelegate`. You are
    /// responsible for keeping a reference to the context menu.
    func addContextMenu(_ contextMenu: ContextMenu) {

        if let existingInteraction = self.interactions.first(where: { $0 is UIContextMenuInteraction }) {
            removeInteraction(existingInteraction)
        }
                                        
        let interaction = contextMenu.setupContextMenuInteraction()
        addInteraction(interaction)
        
    }
    
    /// Creates & adds a context menu to the target, using a provider.
    ///
    /// - parameter provider: The context menu providing closure.
    /// - returns: The created context menu.
    ///
    /// `ContextMenu` **does not** keep a strong reference to its underlying
    /// `UIContextMenuInteraction` or `UIContextMenuInteractionDelegate`. You are
    /// responsible for keeping a reference to the context menu.
    func addContextMenu(provider: @escaping ContextMenu.Provider) -> ContextMenu {
        
        let contextMenu = ContextMenu(provider: provider)
        addContextMenu(contextMenu)
        
        return contextMenu
        
    }
    
    /// Removes a context menu from the target.
    ///
    /// - parameter contextMenu: The context menu to remove.
    func removeContextMenu(_ contextMenu: ContextMenu) {
        
        guard let interaction = contextMenu.contextMenuInteraction,
              let view = self as? UIView,
              interaction.view == view else { return }
        
        removeInteraction(interaction)
        
    }

}
