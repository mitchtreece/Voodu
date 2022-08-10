//
//  MenuTarget.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

@available(iOS 14, *)
public protocol MenuTarget: AnyObject {
    
    var menu: UIMenu? { get set }
    var contextMenuInteraction: UIContextMenuInteraction? { get }

}

@available(iOS 14, *)
public extension MenuTarget {
    
    func addMenu(_ menu: Menu) -> MenuInteraction {

        menu.setup(for: self)
        return menu
        
    }

    func addMenu(provider: @escaping Menu.Provider) -> MenuInteraction {

        let menu = Menu(provider: provider)
        return addMenu(menu)
        
    }

    func removeMenu(for interaction: MenuInteraction) {
        
        guard let interactionMenu = interaction as? Menu,
              interactionMenu == self.targetMenu else { return }
        
        self.targetMenu = nil
        self.menu = nil
        
    }
    
}

@available(iOS 14, *)
internal extension MenuTarget {
    
    var targetMenu: Menu? {
        get {
            
            if let button = self as? UIButton {
                return button.buttonMenu
            }
            else if let item = self as? UIBarButtonItem {
                return item.itemMenu
            }
            
            return nil
            
        }
        set {
            
            if let button = self as? UIButton {
                button.buttonMenu = newValue
            }
            else if let item = self as? UIBarButtonItem {
                item.itemMenu = newValue
            }
            
        }
    }

    func swizzleMenuIfNeeded() {
        
        if let _ = self as? UIButton {
            UIButton.swizzleMenuIfNeeded()
        }
        else if let _ = self as? UIBarButtonItem {
            UIBarButtonItem.swizzleMenuIfNeeded()
        }
        
    }
    
}
