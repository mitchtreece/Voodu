//
//  MenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// Menu interaction object.
public struct MenuInteraction {
    
    internal weak var menu: Menu?
    
    internal init(menu: Menu) {
        self.menu = menu
    }
    
    // MARK: UIContextMenuInteraction
    
    /// Updates the currently visible menu.
    ///
    /// This method does nothing if a menu is not currently being presented for this interaction.
    @available(iOS 14, *)
    func updateVisible(block: (UIMenu)->UIMenu) {
                
        self.menu?
            .target?
            .contextMenuInteraction?
            .updateVisibleMenu(block)
        
    }
    
    /// Dismisses the currently visible menu.
    ///
    /// This method does nothing if a menu is not currently being presented for this interaction.
    func dismiss() {
                
        self.menu?
            .target?
            .contextMenuInteraction?
            .dismissMenu()
        
    }
    
}
