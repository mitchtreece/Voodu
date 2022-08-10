//
//  ShortcutMenuBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/10/22.
//

import UIKit

public typealias ShortcutMenuProvider = (inout ShortcutMenuBuildable)->()

public protocol ShortcutMenuBuildable {
    
    var items: [UIApplicationShortcutItem] { get set }
    
}

public extension ShortcutMenuBuildable {
    
    mutating func addItem(_ item: UIApplicationShortcutItem) {
        self.items.append(item)
    }
    
    @discardableResult
    mutating func addItem(builder: ShortcutMenuItemProvider) -> String {
        
        var buildable: ShortcutMenuItemBuildable = ShortcutMenuItemBuilder()
        builder(&buildable)
        
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
