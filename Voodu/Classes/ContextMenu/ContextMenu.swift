//
//  ContextMenu.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public class ContextMenu {
    
    public typealias Provider = (MenuData, inout ContextMenuBuildable)->()
    public typealias PreviewProvider = ()->UIViewController?
    public typealias PreviewCommitter = (UIViewController?)->()
    public typealias TargetedPreviewProvider = ()->UITargetedPreview?
    
    internal private(set) var title: String?
    internal private(set) var identifier: String?
    internal private(set) var configurationIdentifier: NSCopying?
    internal private(set) var options: UIMenu.Options = []
    internal private(set) var elements: [UIMenuElement] = []
    internal private(set) var previewProvider: ContextMenu.PreviewProvider?
    internal private(set) var previewCommitter: ContextMenu.PreviewCommitter?
    internal private(set) var previewCommitStyle: UIContextMenuInteractionCommitStyle = .pop
    internal private(set) var targetedHighlightPreviewProvider: ContextMenu.TargetedPreviewProvider?
    internal private(set) var targetedDismissPreviewProvider: ContextMenu.TargetedPreviewProvider?
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
    
    //////
    
    private let provider: Provider
    private var delegate: ContextMenuInteractionDelegate!
    
    internal private(set) weak var contextMenuInteraction: UIContextMenuInteraction?
    
    internal var data = MenuData()
    
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
    
    @discardableResult
    public func setData(_ data: Any?,
                        forKey key: String) -> Self {
        
        self.data.set(
            data,
            forKey: key
        )
        
        return self
        
    }
    
    public func getData(_ key: String) -> Any? {
        return self.data.get(key)
    }
    
    // MARK: Interactions
    
    public func interaction() -> ContextMenuInteraction {
        return ContextMenuInteraction(contextMenu: self)
    }
    
    public func tableInteraction() -> ContextMenuTableInteraction {
        return ContextMenuTableInteraction(contextMenu: self)
    }
    
    public func collectionInteraction() -> ContextMenuCollectionInteraction {
        return ContextMenuCollectionInteraction(contextMenu: self)
    }
    
    // MARK: Private

    internal func setupMenuInteraction() -> UIContextMenuInteraction {
        
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
        self.previewCommitter = buildable.previewCommitter
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
