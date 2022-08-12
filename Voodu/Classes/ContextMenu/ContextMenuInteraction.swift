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
    
    // MARK: Add & Remove
        
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

    // MARK: UIContextMenuInteraction
    
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
