//
//  ActionBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public typealias ActionProvider = (inout ActionBuildable)->()

public protocol ActionBuildable {
    
    var title: String { get set }
    var image: UIImage? { get set }
    var identifier: String? { get set }
    var discoverabilityTitle: String? { get set }
    var attributes: UIMenuElement.Attributes { get set }
    var state: UIMenuElement.State { get set }
    var handler: UIActionHandler { get set }
    
    @available(iOS 15, *)
    var subtitle: String? { get set }
    
}

internal struct ActionBuilder: ActionBuildable {
    
    var title: String = ""
    var image: UIImage?
    var identifier: String?
    var discoverabilityTitle: String?
    var attributes: UIMenuElement.Attributes = []
    var state: UIMenuElement.State = .off
    var handler: UIActionHandler = { _ in }
        
    @available(iOS 15, *)
    var subtitle: String? {
        get {
            return self._subtitle
        }
        set {
            self._subtitle = newValue
        }
    }
    
    private var _subtitle: String?
    
    init() {
        //
    }

    func build() -> UIAction {
        return UIAction(buildable: self)
    }
    
}

public extension UIAction {
    
    convenience init(builder: ActionProvider) {
        
        var buildable: ActionBuildable = ActionBuilder()
        
        builder(&buildable)

        self.init(buildable: buildable)
        
    }

}

internal extension UIAction {

    convenience init(buildable: ActionBuildable) {

        self.init(
            title: buildable.title,
            image: buildable.image,
            identifier: (buildable.identifier != nil) ? .init(buildable.identifier!) : nil,
            discoverabilityTitle: buildable.discoverabilityTitle,
            attributes: buildable.attributes,
            state: buildable.state,
            handler: buildable.handler
        )

        if #available(iOS 15, *) {
            self.subtitle = buildable.subtitle
        }

    }

}
