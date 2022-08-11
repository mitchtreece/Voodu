//
//  MenuInteraction.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public struct MenuInteraction {
    
    internal private(set) var menu: Menu!
    
    internal init(menu: Menu) {
        self.menu = menu
    }
    
    @available(iOS 14, *)
    func updateVisible(block: (UIMenu)->UIMenu) {
        
        guard let target = self.menu.target else { return }
        
        target
            .contextMenuInteraction?
            .updateVisibleMenu(block)
        
    }
    
    func dismiss() {
        
        guard let target = self.menu.target else { return }
        
        target
            .contextMenuInteraction?
            .dismissMenu()
        
    }
    
}
