//
//  MenuElementContainer.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// Protocol describing the characteristics of something
/// that contains a collection of `UIMenuElement`.
public protocol MenuElementContainer {
    
    /// The container's menu elements.
    var elements: [UIMenuElement] { get set }
    
}

public extension MenuElementContainer {

    /// Adds a menu element.
    ///
    /// - parameter element: The menu element to add.
    mutating func addElement(_ element: UIMenuElement) {
        self.elements.append(element)
    }

    /// Adds an action element, using a provider.
    ///
    /// - parameter provider: The action providing closure.
    /// - returns: The added action's identifier.
    @discardableResult
    mutating func addAction(provider: ActionProvider) -> String {

        var buildable: ActionBuildable = ActionBuilder()
        provider(&buildable)

        let action = (buildable as! ActionBuilder).build()
        addElement(action)

        return action.identifier.rawValue

    }

    /// Adds a menu element, using a provider.
    ///
    /// - parameter provider: The menu providing closure.
    /// - returns: The added menu's identifier.
    @discardableResult
    mutating func addMenu(provider: Menu.Provider) -> String {

        var buildable: MenuBuildable = MenuBuilder()
        provider(&buildable)

        let menu = (buildable as! MenuBuilder).build()
        addElement(menu)

        return menu.identifier.rawValue

    }

    /// Adds a deferred menu element.
    ///
    /// - parameter block: The deferred elements providing closure.
    @available(iOS 14, *)
    mutating func addDeferredElements(provider: @escaping (@escaping ([UIMenuElement])->())->()) {

        // Not using builders here because we only pass in one (required) thing.
        // Also, the way to init an `uncached` deferred element is a static function,
        // so the builder pattern `init(buildable:)` won't work.

        addElement(UIDeferredMenuElement(provider))

    }

}
