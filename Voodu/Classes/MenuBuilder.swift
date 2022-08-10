//
//  MenuBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public typealias MenuProvider = (inout MenuBuildable)->()

public protocol MenuBuildable: MenuElementContainer {
    
    var title: String { get set }
    var image: UIImage? { get set }
    var identifier: String? { get set }
    var options: UIMenu.Options { get set }
    
    // Only applies to MenuTarget's, not
    // directly building a `UIMenu`.
    var willPresent: (()->())? { get set }
    var willDismiss: (()->())? { get set }
    ////////////////////////////////////
    
    @available(iOS 15, *)
    var subtitle: String? { get set }
    
    @available(iOS 16, *)
    var elementSize: UIMenu.ElementSize { get set }
        
}

internal struct MenuBuilder: MenuBuildable {
        
    var title: String = ""
    var image: UIImage?
    var identifier: String?
    var options: UIMenu.Options = []
    var elements: [UIMenuElement] = []
    var willPresent: (()->())?
    var willDismiss: (()->())?
    
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

    convenience init(builder: MenuProvider) {
                
        var buildable: MenuBuildable = MenuBuilder()
        
        builder(&buildable)
        
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
