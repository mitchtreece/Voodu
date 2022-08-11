//
//  ContextMenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public struct ContextMenuInteraction {
    
    internal let contextMenu: ContextMenu
    
    internal init(contextMenu: ContextMenu) {
        self.contextMenu = contextMenu
    }
        
    @discardableResult
    func add(to target: ContextMenuTarget) -> ContextMenuInteraction {
                
        return target
            .addContextMenu(self.contextMenu)
                
    }
    
    func removeFromTarget() {
        
        self.contextMenu
            .contextMenuInteraction?
            .view?
            .removeContextMenu(self.contextMenu)
        
    }
    
    @available(iOS 14, *)
    public func updateVisible(block: (UIMenu)->UIMenu) {
                
        self.contextMenu
            .contextMenuInteraction?
            .updateVisibleMenu(block)
        
    }
    
    public func dismiss() {
                
        self.contextMenu
            .contextMenuInteraction?
            .dismissMenu()
        
    }
    
}
