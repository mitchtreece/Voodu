//
//  MenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public protocol MenuInteraction {}

@available(iOS 14, *)
public extension MenuInteraction {
    
    func updateVisible(block: (UIMenu)->UIMenu) {
        
        guard let menu = self as? Menu,
              let menuTarget = menu.target else { return }
        
        menuTarget
            .contextMenuInteraction?
            .updateVisibleMenu(block)
        
    }
    
    func dismiss() {
        
        guard let menu = self as? Menu,
              let menuTarget = menu.target else { return }
        
        menuTarget
            .contextMenuInteraction?
            .dismissMenu()
        
    }
    
}
