//
//  MenuBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// Protocol describing the characteristics of something that can build a `Menu`.
public protocol MenuBuildable: MenuElementContainer {
    
    /// The menu's title.
    var title: String { get set }
    
    /// The menu's icon image.
    var image: UIImage? { get set }
    
    /// The menu's identifier.
    var identifier: String? { get set }
    
    /// The menu's options.
    var options: UIMenu.Options { get set }
    
    /// The menu's subtitle.
    @available(iOS 15, *)
    var subtitle: String? { get set }
    
    /// The menu's element size.
    @available(iOS 16, *)
    var elementSize: UIMenu.ElementSize { get set }
        
}

internal struct MenuBuilder: MenuBuildable {
        
    var title: String = ""
    var image: UIImage?
    var identifier: String?
    var options: UIMenu.Options = []
    var elements: [UIMenuElement] = []

    @available(iOS 15, *)
    var subtitle: String? {
        get {
            return self._subtitle
        }
        set {
            self._subtitle = newValue
        }
    }
    
    @available(iOS 16, *)
    var elementSize: UIMenu.ElementSize {
        get {
            return (self._elementSize as? UIMenu.ElementSize) ?? .large
        }
        set {
            self._elementSize = newValue
        }
    }
    
    private var _subtitle: String?
    private var _elementSize: Any?
    
    init() {
        //
    }

    func build() -> UIMenu {
        return UIMenu(buildable: self)
    }
    
}

public extension UIMenu {

    /// Initializes a menu, using a provider.
    ///
    /// - parameter provider: The menu providing closure.
    convenience init(provider: Menu.Provider) {
                
        var buildable: MenuBuildable = MenuBuilder()
        
        provider(&buildable)
        
        self.init(buildable: buildable)
        
    }

}

internal extension UIMenu {
    
    convenience init(buildable: MenuBuildable) {

        self.init(
            title: buildable.title,
            image: buildable.image,
            identifier: (buildable.identifier != nil) ? .init(buildable.identifier!) : nil,
            options: buildable.options,
            children: buildable.elements
        )
        
        if #available(iOS 15, *) {
            self.subtitle = buildable.subtitle
        }
        
        if #available(iOS 16, *) {
            self.preferredElementSize = buildable.elementSize
        }
        
    }
    
}
