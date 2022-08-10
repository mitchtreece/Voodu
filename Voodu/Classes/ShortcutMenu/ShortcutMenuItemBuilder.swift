//
//  ShortcutMenuItemBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/9/22.
//

import UIKit

public typealias ShortcutMenuItemProvider = (inout ShortcutMenuItemBuildable)->()

public protocol ShortcutMenuItemBuildable {
    
    var identifier: String { get set }
    var title: String { get set }
    var subtitle: String? { get set }
    var image: UIApplicationShortcutIcon? { get set }
    var data: [String: NSSecureCoding]? { get set }
    
}

internal struct ShortcutMenuItemBuilder: ShortcutMenuItemBuildable {
    
    var identifier: String = UUID().uuidString
    var title: String = ""
    var subtitle: String?
    var image: UIApplicationShortcutIcon?
    var data: [String : NSSecureCoding]?
    
    init() {
        //
    }

    func build() -> UIApplicationShortcutItem {
        return UIApplicationShortcutItem(buildable: self)
    }
    
}

public extension UIApplicationShortcutItem {

    convenience init(builder: ShortcutMenuItemProvider) {
                
        var buildable: ShortcutMenuItemBuildable = ShortcutMenuItemBuilder()
        
        builder(&buildable)
        
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
            userInfo: buildable.data
        )
        
    }
    
}
