//
//  Menu.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public class Menu: NSObject {
    
    public typealias Provider = (inout MenuBuildable)->()
     
    internal private(set) var title: String = ""
    internal private(set) var image: UIImage?
    internal private(set) var identifier: String?
    internal private(set) var options: UIMenu.Options = []
    internal private(set) var elements: [UIMenuElement] = []

    @available(iOS 15, *)
    internal private(set) var subtitle: String? {
        get {
            return self._subtitle
        }
        set {
            self._subtitle = newValue
        }
    }
    
    @available(iOS 16, *)
    internal private(set) var elementSize: UIMenu.ElementSize {
        get {
            return (self._elementSize as? UIMenu.ElementSize) ?? .large
        }
        set {
            self._elementSize = newValue
        }
    }
    
    private var _subtitle: String?
    private var _elementSize: Any?
    
    private let provider: Provider
    
    internal private(set) weak var target: MenuTarget?
    
    public init(provider: @escaping Provider) {

        self.provider = provider
        
        super.init()

        var buildable: MenuBuildable = MenuBuilder()
        self.provider(&buildable)
        update(using: buildable)

    }
    
    public func interaction() -> MenuInteraction {
        return MenuInteraction(menu: self)
    }
    
    // MARK: Private
    
    internal func setup(target: MenuTarget) {
        
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

        if #available(iOS 15, *) {
            self.subtitle = buildable.subtitle
        }

        if #available(iOS 16, *) {
            self.elementSize = buildable.elementSize
        }
        
    }
    
    internal func menu() -> UIMenu {
                
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
