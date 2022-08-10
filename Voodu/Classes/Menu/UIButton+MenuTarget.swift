//
//  UIButton+MenuTarget.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

@available(iOS 14, *)
extension UIButton: MenuTarget {
    
    private struct AssociatedKeys {
        
        static var buttonMenu: UInt8 = 0
        static var didSwizzleMenu: UInt8 = 0
        
    }
    
    private var menuKey: String {
        
        return ["u", "n", "e", "m", "_"]
            .reversed()
            .joined()
        
    }
    
    internal var buttonMenu: Menu? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.buttonMenu) as? Menu
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.buttonMenu, newValue, .OBJC_ASSOCIATION_ASSIGN)
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
           
            let originalSelector = #selector(getter: self.menu)
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            
            let swizzledSelector = #selector(swizzledMenu)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            guard let originalMethod = originalMethod,
                  let swizzledMethod = swizzledMethod else { return }
            
            method_exchangeImplementations(
                originalMethod,
                swizzledMethod
            )
            
        }()
        
        self.didSwizzleMenu = true
        
    }
    
    @objc private func swizzledMenu() -> UIMenu? {
        
        let menu = value(forKey: self.menuKey) as? UIMenu
        return self.buttonMenu?.menu() ?? menu
        
    }
    
    // MARK: UIContextMenuInteractionDelegate
    
    open override func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                              willDisplayMenuFor configuration: UIContextMenuConfiguration,
                                              animator: UIContextMenuInteractionAnimating?) {
                
        self.buttonMenu?
            .willPresent?()
        
        super.contextMenuInteraction(
            interaction,
            willDisplayMenuFor: configuration,
            animator: animator
        )
        
    }

    open override func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                              willEndFor configuration: UIContextMenuConfiguration,
                                              animator: UIContextMenuInteractionAnimating?) {

        self.buttonMenu?
            .willDismiss?()
        
        super.contextMenuInteraction(
            interaction,
            willEndFor: configuration,
            animator: animator
        )

    }
    
}
