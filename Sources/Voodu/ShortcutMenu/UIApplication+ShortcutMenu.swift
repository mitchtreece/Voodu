//
//  UIApplication+ShortcutMenu.swift
//  Menus
//
//  Created by Mitch Treece on 8/10/22.
//

import UIKit

public extension UIApplication {
    
    /// Creates & adds a shortcut menu to the application, using a provider.
    ///
    /// - parameter provider: The shortcut menu providing closure.
    func addShortcutMenu(provider: ShortcutMenuProvider) {
        
        var buildable: ShortcutMenuBuildable = ShortcutMenuBuilder()
        provider(&buildable)
        
        let items = (buildable as! ShortcutMenuBuilder).build()
        self.shortcutItems = items
        
    }
    
}
