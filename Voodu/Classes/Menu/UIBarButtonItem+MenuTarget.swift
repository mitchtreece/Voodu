//
//  UIBarButtonItem+MenuTarget.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

@available(iOS 14, *)
extension UIBarButtonItem: MenuTarget {

    private struct AssociatedKeys {
        
        static var itemMenu: UInt8 = 0
        static var didSwizzleMenu: UInt8 = 0
        static var didAddMenuAction: UInt8 = 0
        
    }
    
    private var menuKey: String {
        
        return ["u", "n", "e", "m", "_"]
            .reversed()
            .joined()
        
    }
    
    private var viewKey: String {
        
        return ["w", "e", "i", "v", "_"]
            .reversed()
            .joined()
        
    }
    
    internal var itemMenu: Menu? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.itemMenu) as? Menu
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.itemMenu, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    internal var control: UIControl? {
        return value(forKey: self.viewKey) as? UIControl
    }
    
    public var contextMenuInteraction: UIContextMenuInteraction? {
                
        // The view here is a subclass of `UIControl`. We can pull
        // the context menu interaction directly from there.
        
        return self.control?
            .contextMenuInteraction
        
    }
    
    internal private(set) var didAddMenuAction: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.didAddMenuAction) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.didAddMenuAction, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    // MARK: Swizzling
    
    internal private(set) static var didSwizzleMenu: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.didSwizzleMenu) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.didSwizzleMenu, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    internal static func swizzleMenuIfNeeded() {
        
        guard !self.didSwizzleMenu else { return }

        let _: () = {
            
            // UIBarButtonItem.menu

            let oMenuSelector = #selector(getter: self.menu)
            let oMenuMethod = class_getInstanceMethod(self, oMenuSelector)

            let sMenuSelector = #selector(swizzled_getMenu)
            let sMenuMethod = class_getInstanceMethod(self, sMenuSelector)

            if let oMenuMethod = oMenuMethod,
               let sMenuMethod = sMenuMethod {

                method_exchangeImplementations(
                    oMenuMethod,
                    sMenuMethod
                )

            }
            
            // UIControl.isHighlighted
            
//            let oHighlightSelector = NSSelectorFromString("setHighlighted:")
//            let imp = class_getMethodImplementation(UIControl.self, oHighlightSelector)
//            let oHighlightMethod = class_getInstanceMethod(UIControl.self, oHighlightSelector)
//
//            let sHighlightSelector = #selector(swizzled_controlSetHighlighted)
//            let sHighlightMethod = class_getInstanceMethod(self, sHighlightSelector)
//
//            guard let oHighlightMethod = oHighlightMethod,
//                  let sHighlightMethod = sHighlightMethod else { return }
//
//            method_exchangeImplementations(
//                oHighlightMethod,
//                sHighlightMethod
//            )

        }()

        self.didSwizzleMenu = true
        
    }
    
    @objc private func swizzled_getMenu() -> UIMenu? {

        let originalMenu = value(forKey: self.menuKey) as? UIMenu
        
        guard let itemMenu = self.itemMenu else {
            return originalMenu
        }
                
        if let control = self.control, !self.didAddMenuAction {

            let action = UIAction(identifier: .init("preheat_menu_action")) { [weak self] _ in
                
                guard let self = self, control.isContextMenuInteractionEnabled else { return }
                
                print("👉🏼 UIBarButtonItem.willPresentMenu")
                
                self.menu = itemMenu.menu()
                
                itemMenu.willPresent?()
                                
            }
            
            control.addAction(
                action,
                for: .touchDown
            )
            
            self.didAddMenuAction = true
            
        }
                
        return itemMenu.menu()
                
    }
    
    @objc private func swizzled_controlSetHighlighted(_ highlighted: Bool) {
                
        print("control highlight - do something here")
        
    }
    
}
