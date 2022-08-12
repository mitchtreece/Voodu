//
//  MenuElementContainer.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

@available(iOS 14, *)
public typealias DeferredMenuElementCompletion = ([UIMenuElement])->()

public protocol MenuElementContainer {
    
    var elements: [UIMenuElement] { get set }
    
}

public extension MenuElementContainer {

    // MARK: Add

    mutating func addElement(_ element: UIMenuElement) {
        self.elements.append(element)
    }

    @discardableResult
    mutating func addAction(provider: ActionProvider) -> String {

        var buildable: ActionBuildable = ActionBuilder()
        provider(&buildable)

        let action = (buildable as! ActionBuilder).build()
        addElement(action)

        return action.identifier.rawValue

    }

    @discardableResult
    mutating func addMenu(provider: MenuProvider) -> String {

        var buildable: MenuBuildable = MenuBuilder()
        provider(&buildable)

        let menu = (buildable as! MenuBuilder).build()
        addElement(menu)

        return menu.identifier.rawValue

    }

    @available(iOS 14, *)
    mutating func addDeferredElements(block: @escaping (@escaping DeferredMenuElementCompletion)->()) {

        // Not using builders here because we only pass in one (required) thing.
        // Also, the way to init an `uncached` deferred element is a static function,
        // so the builder pattern `init(buildable:)` won't work.

        addElement(UIDeferredMenuElement(block))

    }

    @available(iOS 15, *)
    mutating func addUncachedDeferredElements(block: @escaping (@escaping DeferredMenuElementCompletion)->()) {

        // Not using builders here because we only pass in one (required) thing.
        // Also, the way to init an `uncached` deferred element is a static function,
        // so the builder pattern `init(buildable:)` won't work.

        addElement(UIDeferredMenuElement.uncached(block))

    }

}
