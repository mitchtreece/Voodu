//
//  ContextMenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public protocol ContextMenuInteraction {}

extension ContextMenuInteraction {
        
    @discardableResult
    func add(to target: ContextMenuTarget) -> ContextMenuInteraction {
        
        let contextMenu = self as! ContextMenu
        
        return target
            .addContextMenu(contextMenu)
                
    }
    
    func removeFromTarget() {
        
        let contextMenu = self as! ContextMenu

        contextMenu
            .interaction?
            .view?
            .removeContextMenu(for: self)
        
    }
    
    @available(iOS 14, *)
    public func updateVisible(block: (UIMenu)->UIMenu) {
        
        let contextMenu = self as! ContextMenu
        
        contextMenu
            .interaction?
            .updateVisibleMenu(block)
        
    }
    
    public func dismiss() {
        
        let contextMenu = self as! ContextMenu
        
        contextMenu
            .interaction?
            .dismissMenu()
        
    }
    
}
