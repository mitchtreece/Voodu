//
//  MenuTarget.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// Protocol describing the characteristics of something
/// that can present a menu.
public protocol MenuTarget: AnyObject {
    
    /// An optional menu for the target to display.
    var menu: UIMenu? { get set }
    
    /// The target's current context menu interaction.
    var contextMenuInteraction: UIContextMenuInteraction? { get }

}

public extension MenuTarget {
    
    /// Adds a menu to the target.
    ///
    /// - parameter menu: The menu to add.
    ///
    /// `Menu` **does not** keep a strong reference to its underlying
    /// `UIContextMenuInteraction` or `UIContextMenuInteractionDelegate`. You are
    /// responsible for keeping a reference to the menu.
    func addMenu(_ menu: Menu) {
        menu.setup(target: self)
    }

    /// Creates & adds a menu to the target, using a provider.
    ///
    /// - parameter provider: The menu providing closure.
    /// - returns: The created menu.
    ///
    /// `Menu` **does not** keep a strong reference to its underlying
    /// `UIContextMenuInteraction` or `UIContextMenuInteractionDelegate`. You are
    /// responsible for keeping a reference to the menu.
    func addMenu(provider: @escaping (inout MenuBuildable)->()) -> Menu {

        let menu = Menu(provider: provider)
        addMenu(menu)
        
        return menu
        
    }
    
    /// Removes a menu from the target.
    ///
    /// - parameter menu: The menu to remove.
    func removeMenu(_ menu: Menu) {
        
        guard menu == self.targetMenu else { return }
        
        self.targetMenu = nil
        self.menu = nil
        
    }
    
}

internal extension MenuTarget {
    
    var targetMenu: Menu? {
        get {
            
            guard #available(iOS 14, *) else { return nil }
            
            if let button = self as? UIButton {
                return button.buttonMenu
            }
            else if let item = self as? UIBarButtonItem {
                return item.itemMenu
            }
            
            return nil
            
        }
        set {
            
            guard #available(iOS 14, *) else { return }
            
            if let button = self as? UIButton {
                button.buttonMenu = newValue
            }
            else if let item = self as? UIBarButtonItem {
                item.itemMenu = newValue
            }
            
        }
    }

    func swizzleMenuIfNeeded() {
        
        guard #available(iOS 14, *) else { return }
        
        if let _ = self as? UIButton {
            UIButton.swizzleMenuIfNeeded()
        }
        else if let _ = self as? UIBarButtonItem {
            UIBarButtonItem.swizzleMenuIfNeeded()
        }
        
    }
    
}
