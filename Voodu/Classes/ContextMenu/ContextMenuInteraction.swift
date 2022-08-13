//
//  ContextMenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// Context menu interaction object.
public struct ContextMenuInteraction {
    
    internal weak var contextMenu: ContextMenu?
    
    internal init(contextMenu: ContextMenu) {
        self.contextMenu = contextMenu
    }
    
    // MARK: Data
    
    /// Sets a piece data for a given key.
    ///
    /// - parameter data: The data.
    /// - parameter key: The key to associate the data to.
    /// - returns: This context menu interaction.
    @discardableResult
    public func setData(_ data: Any?,
                        forKey key: String) -> Self {
        
        self.contextMenu?.data.set(
            data,
            forKey: key
        )
        
        return self
        
    }

    // MARK: UIContextMenuInteraction
    
    /// Updates the currently visible menu.
    ///
    /// This method does nothing if a menu is not currently being presented for this interaction.
    @available(iOS 14, *)
    public func updateVisible(block: (UIMenu)->UIMenu) {
        
        self.contextMenu?
            .contextMenuInteraction?
            .updateVisibleMenu(block)
        
    }
    
    /// Dismisses the currently visible menu.
    ///
    /// This method does nothing if a menu is not currently being presented for this interaction.
    public func dismiss() {
                
        self.contextMenu?
            .contextMenuInteraction?
            .dismissMenu()
        
    }
    
}
