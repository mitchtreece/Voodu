//
//  ContextMenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public struct ContextMenuInteraction {
    
    internal weak var contextMenu: ContextMenu?
    
    internal init(contextMenu: ContextMenu) {
        self.contextMenu = contextMenu
    }
    
    // MARK: Remove

    func removeFromTarget() {
        
        guard let contextMenu = self.contextMenu else { return }
        
        contextMenu
            .contextMenuInteraction?
            .view?
            .removeContextMenu(contextMenu)
        
    }
    
    // MARK: Data
    
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
    
    @available(iOS 14, *)
    public func updateVisible(block: (UIMenu)->UIMenu) {
                
        self.contextMenu?
            .contextMenuInteraction?
            .updateVisibleMenu(block)
        
    }
    
    public func dismiss() {
                
        self.contextMenu?
            .contextMenuInteraction?
            .dismissMenu()
        
    }
    
}
