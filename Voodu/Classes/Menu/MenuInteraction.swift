//
//  MenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public struct MenuInteraction {
    
    internal weak var menu: Menu?
    
    internal init(menu: Menu) {
        self.menu = menu
    }
    
    @available(iOS 14, *)
    func updateVisible(block: (UIMenu)->UIMenu) {
                
        self.menu?
            .target?
            .contextMenuInteraction?
            .updateVisibleMenu(block)
        
    }
    
    func dismiss() {
                
        self.menu?
            .target?
            .contextMenuInteraction?
            .dismissMenu()
        
    }
    
}
