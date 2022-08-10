//
//  Menu.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

@available(iOS 14, *)
public class Menu: NSObject, MenuInteraction {
    
    public typealias Provider = (inout MenuBuildable)->()
 
    private var title: String = ""
    private var image: UIImage?
    private var identifier: String?
    private var options: UIMenu.Options = []
    private var elements: [UIMenuElement] = []
    internal private(set) var willPresent: (()->())?
    internal private(set) var willDismiss: (()->())?
    
    @available(iOS 15, *)
    private var subtitle: String? {
        get {
            return self._subtitle
        }
        set {
            self._subtitle = newValue
        }
    }
    
    @available(iOS 16, *)
    private var elementSize: UIMenu.ElementSize {
        get {
            return (self._elementSize as? UIMenu.ElementSize) ?? .large
        }
        set {
            self._elementSize = newValue
        }
    }
    
    private var _subtitle: String?
    private var _elementSize: Any?
    
    private var provider: Provider
    internal private(set) weak var target: MenuTarget?
    
    public init(provider: @escaping Provider) {

        self.provider = provider
        
        super.init()

        var buildable: MenuBuildable = MenuBuilder()
        self.provider(&buildable)
        update(using: buildable)

    }
    
    // MARK: Private
    
    internal func setup(for target: MenuTarget) {
        
        self.target = target
        self.target?.swizzleMenuIfNeeded()
        self.target?.targetMenu = self
        self.target?.menu = menu()
        
    }
    
    private func update(using buildable: MenuBuildable) {
        
        self.title = buildable.title
        self.image = buildable.image
        self.identifier = buildable.identifier
        self.options = buildable.options
        self.elements = buildable.elements
        self.willPresent = buildable.willPresent
        self.willDismiss = buildable.willDismiss

        if #available(iOS 15, *) {
            self.subtitle = buildable.subtitle
        }

        if #available(iOS 16, *) {
            self.elementSize = buildable.elementSize
        }
        
    }
    
    internal func menu() -> UIMenu {
        
        print("👉🏼 Menu.menu()")
        
        var buildable: MenuBuildable = MenuBuilder()
        self.provider(&buildable)
        update(using: buildable)
        
        let menu = UIMenu(
            title: self.title,
            identifier: (self.identifier != nil) ? UIMenu.Identifier(self.identifier!) : nil,
            options: self.options,
            children: self.elements
        )

        if #available(iOS 16, *) {
            menu.preferredElementSize = self.elementSize
        }
                
        return menu

    }
    
}
