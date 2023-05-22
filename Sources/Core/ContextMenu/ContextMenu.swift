//
//  ContextMenu.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// A contextual menu that manages the setup, presentation, & interaction
/// of a `UIContextMenuInteraction` & `UIContextMenuInteractionDelegate`.
public class ContextMenu {
    
    /// A context menu provider used to create _or_ update a `ContextMenu`.
    public typealias Provider = (ContextMenuData, inout ContextMenuBuildable)->()
    
    internal private(set) var title: String?
    internal private(set) var identifier: String?
    internal private(set) var configurationIdentifier: NSCopying?
    internal private(set) var options: UIMenu.Options = []
    internal private(set) var elements: [UIMenuElement] = []
    internal private(set) var previewProvider: (()->UIViewController?)?
    internal private(set) var previewCommitAction: ((UIViewController?)->())?
    internal private(set) var previewCommitStyle: UIContextMenuInteractionCommitStyle = .pop
    internal private(set) var targetedHighlightPreviewProvider: (()->UITargetedPreview?)?
    internal private(set) var targetedDismissPreviewProvider: (()->UITargetedPreview?)?
    internal private(set) var includeSuggestedElements: Bool = false
    internal private(set) var willPresent: (()->())?
    internal private(set) var willDismiss: (()->())?
    
    @available(iOS 16, *)
    internal private(set) var elementSize: UIMenu.ElementSize {
        get {
            return (self._elementSize as? UIMenu.ElementSize) ?? .large
        }
        set {
            self._elementSize = newValue
        }
    }
    
    private var _elementSize: Any?
        
    private let provider: Provider
    private var delegate: ContextMenuInteractionDelegate!
    
    internal private(set) weak var contextMenuInteraction: UIContextMenuInteraction?
    
    internal var data = ContextMenuData()
    
    // MARK: Initializers
    
    /// Initializes a context menu using a provider.
    ///
    /// - parameter provider: The context menu providing closure.
    ///
    /// `ContextMenu` **does not** keep a strong reference to its underlying
    /// `UIContextMenuInteraction` or `UIContextMenuInteractionDelegate`.
    public init(provider: @escaping Provider) {

        self.provider = provider
        self.delegate = ContextMenuInteractionDelegate(contextMenu: self)
        
        var buildable: ContextMenuBuildable = ContextMenuBuilder()
        
        self.provider(
            self.data,
            &buildable
        )
        
        update(using: buildable)

    }
    
    // MARK: Data
    
    /// Sets a piece data for a given key.
    ///
    /// - parameter data: The data.
    /// - parameter key: The key to associate the data to.
    /// - returns: This context menu.
    @discardableResult
    public func setData(_ data: Any?,
                        forKey key: String) -> Self {
        
        self.data.set(
            data,
            forKey: key
        )
        
        return self
        
    }
    
    /// Retrieves a piece of data associated with a given key.
    ///
    /// - parameter key: The associated data's key.
    /// - returns: The associated data.
    public func getData(_ key: String) -> Any? {
        return self.data.get(key)
    }
    
    // MARK: Interactions
    
    /// Returns a new interaction for this context menu.
    ///
    /// - returns: A context menu interaction.
    public func asInteraction() -> ContextMenuInteraction {
        return ContextMenuInteraction(contextMenu: self)
    }
    
    /// Returns a new table-interaction for this context menu.
    ///
    /// - returns: A context menu table-interaction.
    public func asTableInteraction() -> ContextMenuTableInteraction {
        return ContextMenuTableInteraction(contextMenu: self)
    }
    
    /// Returns a new collection-interaction for this context menu.
    ///
    /// - returns: A context menu table-interaction.
    public func asCollectionInteraction() -> ContextMenuCollectionInteraction {
        return ContextMenuCollectionInteraction(contextMenu: self)
    }
    
    // MARK: Helpers
    
    /// Returns a menu representation of this context menu.
    ///
    /// - returns: A menu.
    public func asMenu() -> Menu {
        
        return Menu { menu in
            
            menu.title = self.title ?? ""
            menu.identifier = self.identifier
            menu.options = self.options
            menu.elements = self.elements

            if #available(iOS 16, *) {
                menu.elementSize = self.elementSize
            }
            
        }
        
    }
    
    // MARK: Private

    internal func setupContextMenuInteraction() -> UIContextMenuInteraction {
        
        let interaction = UIContextMenuInteraction(delegate: self.delegate)
        self.contextMenuInteraction = interaction
        return interaction
        
    }
    
    private func update(using buildable: ContextMenuBuildable) {
        
        self.title = buildable.title
        self.identifier = buildable.identifier
        self.configurationIdentifier = buildable.configurationIdentifier
        self.options = buildable.options
        self.elements = buildable.elements
        self.previewProvider = buildable.previewProvider
        self.previewCommitAction = buildable.previewCommitAction
        self.previewCommitStyle = buildable.previewCommitStyle
        self.targetedHighlightPreviewProvider = buildable.targetedHighlightPreviewProvider
        self.targetedDismissPreviewProvider = buildable.targetedDismissPreviewProvider
        self.includeSuggestedElements = buildable.includeSuggestedElements
        self.willPresent = buildable.willPresent
        self.willDismiss = buildable.willDismiss
        
        if #available(iOS 16, *) {
            self.elementSize = buildable.elementSize
        }
        
    }
    
    internal func configuration() -> UIContextMenuConfiguration {
        
        // Ask our provider for an updated layout
        
        var buildable: ContextMenuBuildable = ContextMenuBuilder()
        
        self.provider(
            self.data,
            &buildable
        )
        
        update(using: buildable)
        
        // Build configuration
        
        var actionProvider: UIContextMenuActionProvider?

        if !self.elements.isEmpty {

            // Only assign an action provider if we have elements.
            // If we don't have elements, we only want to show
            // a preview (if provided).

            actionProvider = { suggestedElements in

                var additionalElements = [UIMenuElement]()

                if self.includeSuggestedElements {
                    additionalElements.append(contentsOf: suggestedElements)
                }

                return self.menu(additionalElements: additionalElements)

            }

        }
        
        return UIContextMenuConfiguration(
            identifier: self.configurationIdentifier,
            previewProvider: self.previewProvider,
            actionProvider: actionProvider
        )
        
    }
    
    private func menu(additionalElements: [UIMenuElement]) -> UIMenu {
        
        var elements = self.elements
        elements.append(contentsOf: additionalElements)
        
        let menu = UIMenu(
            title: self.title ?? "",
            identifier: (self.identifier != nil) ? UIMenu.Identifier(self.identifier!) : nil,
            options: self.options,
            children: elements
        )

        if #available(iOS 16, *) {
            menu.preferredElementSize = self.elementSize
        }
                
        return menu

    }
    
}
