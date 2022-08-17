//
//  ShortcutMenuItemBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/9/22.
//

import UIKit

/// A shortcut menu item provider used to create a `UIApplicationShortcutItem`.
public typealias ShortcutMenuItemProvider = (inout ShortcutMenuItemBuildable)->()

/// Protocol describing the characteristics of something that can build a shortcut menu item.
public protocol ShortcutMenuItemBuildable {
    
    /// The shortcut menu item's identifier (type).
    var identifier: String { get set }
    
    /// The shortcut menu item's title.
    var title: String { get set }
    
    /// The shortcut menu item's subtitle.
    var subtitle: String? { get set }
    
    /// The shortcut menu item's icon image.
    var image: UIApplicationShortcutIcon? { get set }
    
    /// The shortcut menu item's user info dictionary.
    var userInfo: [String: NSSecureCoding]? { get set }
    
}

internal struct ShortcutMenuItemBuilder: ShortcutMenuItemBuildable {
    
    var identifier: String = UUID().uuidString
    var title: String = ""
    var subtitle: String?
    var image: UIApplicationShortcutIcon?
    var userInfo: [String: NSSecureCoding]?
    
    init() {
        //
    }

    func build() -> UIApplicationShortcutItem {
        return UIApplicationShortcutItem(buildable: self)
    }
    
}

// MARK: UIApplicationShortcutItem

public extension UIApplicationShortcutItem {
    
    /// Initializes an application shortcut item, using a provider.
    ///
    /// - parameter provider: The shortcut menu item providing closure.
    convenience init(provider: ShortcutMenuItemProvider) {
                
        var buildable: ShortcutMenuItemBuildable = ShortcutMenuItemBuilder()
        
        provider(&buildable)
        
        self.init(buildable: buildable)
        
    }

}

internal extension UIApplicationShortcutItem {
    
    convenience init(buildable: ShortcutMenuItemBuildable) {

        self.init(
            type: buildable.identifier,
            localizedTitle: buildable.title,
            localizedSubtitle: buildable.subtitle,
            icon: buildable.image,
            userInfo: buildable.userInfo
        )
        
    }
    
}
