//
//  UIApplication+ShortcutMenu.swift
//  Menus
//
//  Created by Mitch Treece on 8/10/22.
//

import UIKit

public extension UIApplication {
    
    func addShortcutMenu(builder: ShortcutMenuProvider) {
        
        var buildable: ShortcutMenuBuildable = ShortcutMenuBuilder()
        builder(&buildable)
        
        let items = (buildable as! ShortcutMenuBuilder).build()
        self.shortcutItems = items
        
    }
    
}
