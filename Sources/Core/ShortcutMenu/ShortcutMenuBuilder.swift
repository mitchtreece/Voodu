//
//  ShortcutMenuBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/10/22.
//

import UIKit

/// A shortcut menu provider.
public typealias ShortcutMenuProvider = (inout ShortcutMenuBuildable)->()

/// Protocol describing the characteristics of something that can build a shortcut menu.
public protocol ShortcutMenuBuildable {
    
    /// The shortcut menu's items.
    var items: [UIApplicationShortcutItem] { get set }
    
}

public extension ShortcutMenuBuildable {
    
    /// Adds a shortcut item.
    ///
    /// - parameter item: The shortcut item to add.
    mutating func addItem(_ item: UIApplicationShortcutItem) {
        self.items.append(item)
    }
    
    /// Adds a shortcut item using a provider.
    ///
    /// - parameter provider: The shortcut item providing closure.
    /// - returns: The added shortcut item's identifier (type).
    @discardableResult
    mutating func addItem(provider: ShortcutMenuItemProvider) -> String {
        
        var buildable: ShortcutMenuItemBuildable = ShortcutMenuItemBuilder()
        provider(&buildable)
        
        let item = (buildable as! ShortcutMenuItemBuilder).build()
        addItem(item)
        
        return item.type
        
    }
    
}

internal struct ShortcutMenuBuilder: ShortcutMenuBuildable {
    
    var items: [UIApplicationShortcutItem] = []
    
    init() {
        //
    }

    func build() -> [UIApplicationShortcutItem] {
        return self.items
    }
    
}
