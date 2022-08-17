//
//  ContextMenuBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

/// Protocol describing the characteristics of something that can build a `ContextMenu`.
public protocol ContextMenuBuildable: MenuElementContainer {
    
    /// The context menu's title.
    var title: String? { get set }
    
    /// The context menu's identifier.
    var identifier: String? { get set }
    
    /// The context menu's configuration identifier.
    var configurationIdentifier: NSCopying? { get set }
    
    /// The context menu's options.
    var options: UIMenu.Options { get set }
    
    /// The context menu's preview providing closure.
    var previewProvider: (()->UIViewController?)? { get set }
    
    /// The context menu's preview commiting action closure.
    var previewCommitAction: ((UIViewController?)->())? { get set }
    
    /// The context menu's preview commit style.
    var previewCommitStyle: UIContextMenuInteractionCommitStyle { get set }
    
    /// The context menu's targeted highlight providing closure.
    var targetedHighlightPreviewProvider: (()->UITargetedPreview?)? { get set }
    
    /// The context menu's targeted dismiss providing closure.
    var targetedDismissPreviewProvider: (()->UITargetedPreview?)? { get set }
    
    /// Flag indicating if system-suggested menu elements should be included.
    var includeSuggestedElements: Bool { get set }
    
    /// The context menu's presentation closure.
    var willPresent: (()->())? { get set }
    
    /// The context menu's dismissal closure.
    var willDismiss: (()->())? { get set }

    /// The context menu's element size.
    @available(iOS 16, *)
    var elementSize: UIMenu.ElementSize { get set }
    
}

public extension ContextMenuBuildable {
    
    /// Adds a context menu preview.
    ///
    /// - parameter provider: The preview providing closure.
    mutating func addPreview(provider: @escaping ()->UIViewController?) {
        self.previewProvider = provider
    }
    
    /// Adds a commit action to the context menu's preview.
    ///
    /// - parameter action: The commit action closure.
    mutating func addPreviewAction(action: @escaping (UIViewController?)->()) {
        self.previewCommitAction = action
    }
    
    /// Adds a custom highlight preview to the context menu.
    ///
    /// - parameter provider: The highlight preview providing closure.
    mutating func addHighlightPreview(provider: @escaping ()->UITargetedPreview?) {
        self.targetedHighlightPreviewProvider = provider
    }
    
    /// Adds a custom dismiss preview to the context menu.
    ///
    /// - parameter provider: The dismiss preview providing closure.
    mutating func addDismissPreview(_ provider: @escaping ()->UITargetedPreview?) {
        self.targetedDismissPreviewProvider = provider
    }
    
    /// Adds a presentation handler to the context menu.
    ///
    /// - parameter handler: The presentation handler.
    mutating func addPresentHandler(handler: @escaping ()->()) {
        self.willPresent = handler
    }
    
    /// Adds a dismissal handler to the context menu.
    ///
    /// - parameter handler: The dismissal handler.
    mutating func addDismissHandler(handler: @escaping ()->()) {
        self.willDismiss = handler
    }
    
}

internal struct ContextMenuBuilder: ContextMenuBuildable {
        
    var title: String?
    var identifier: String?
    var configurationIdentifier: NSCopying?
    var options: UIMenu.Options = []
    var elements: [UIMenuElement] = []
    var previewProvider: (()->UIViewController?)?
    var previewCommitAction: ((UIViewController?)->())?
    var previewCommitStyle: UIContextMenuInteractionCommitStyle = .pop
    var targetedHighlightPreviewProvider: (()->UITargetedPreview?)?
    var targetedDismissPreviewProvider: (()->UITargetedPreview?)?
    var includeSuggestedElements: Bool = false
    var willPresent: (()->())?
    var willDismiss: (()->())?
    
    @available(iOS 16, *)
    var elementSize: UIMenu.ElementSize {
        get {
            return (self._elementSize as? UIMenu.ElementSize) ?? .large
        }
        set {
            self._elementSize = newValue
        }
    }
    
    private var _elementSize: Any?
    
    init() {
        //
    }
    
}
