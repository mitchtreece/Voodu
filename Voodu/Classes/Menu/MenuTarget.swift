//
//  MenuTarget.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public protocol MenuTarget: AnyObject {
    
    var menu: UIMenu? { get set }
    var contextMenuInteraction: UIContextMenuInteraction? { get }

}

public extension MenuTarget {
    
    func addMenu(_ menu: Menu) {
        menu.setup(target: self)
    }

    func addMenu(provider: @escaping (inout MenuBuildable)->()) -> Menu {

        let menu = Menu(provider: provider)
        addMenu(menu)
        
        return menu
        
    }
    
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
