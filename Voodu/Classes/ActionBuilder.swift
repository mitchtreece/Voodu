//
//  ActionBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// An action provider used to create a `UIAction`.
public typealias ActionProvider = (inout ActionBuildable)->()

/// Protocol describing the characteristics of something that can build a `UIAction`.
public protocol ActionBuildable {
    
    /// The action's title.
    var title: String { get set }
    
    /// The action's icon image.
    var image: UIImage? { get set }
    
    /// The action's identifier.
    var identifier: String? { get set }
    
    /// The action's discoverability title.
    var discoverabilityTitle: String? { get set }
    
    /// The action's menu attributes.
    var attributes: UIMenuElement.Attributes { get set }
    
    /// The action's menu state.
    var state: UIMenuElement.State { get set }
    
    /// The action's handler.
    var handler: UIActionHandler { get set }
    
    /// The action's subtitle.
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

// MARK: UIAction

public extension UIAction {
    
    /// Initializes an action, using a provider.
    ///
    /// - parameter provider: The action providing closure.
    convenience init(provider: ActionProvider) {
        
        var buildable: ActionBuildable = ActionBuilder()
        
        provider(&buildable)

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
