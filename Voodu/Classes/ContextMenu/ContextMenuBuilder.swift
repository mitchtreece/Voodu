//
//  ContextMenuBuilder.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public protocol ContextMenuBuildable: MenuElementContainer {
    
    var title: String? { get set }
    var identifier: String? { get set }
    var configurationIdentifier: NSCopying? { get set }
    var options: UIMenu.Options { get set }
    var previewProvider: (()->UIViewController?)? { get set }
    var previewCommitter: ((UIViewController?)->())? { get set }
    var previewCommitStyle: UIContextMenuInteractionCommitStyle { get set }
    var targetedHighlightPreviewProvider: (()->UITargetedPreview?)? { get set }
    var targetedDismissPreviewProvider: (()->UITargetedPreview?)? { get set }
    var includeSuggestedElements: Bool { get set }
    var willPresent: (()->())? { get set }
    var willDismiss: (()->())? { get set }

    @available(iOS 16, *)
    var elementSize: UIMenu.ElementSize { get set }
    
}

public extension ContextMenuBuildable {
    
    mutating func addPreview(_ provider: @escaping ()->UIViewController?) {
        self.previewProvider = provider
    }
    
    mutating func addPreviewCommitter(_ committer: @escaping (UIViewController?)->()) {
        self.previewCommitter = committer
    }
    
    mutating func addHighlightPreview(_ provider: @escaping ()->UITargetedPreview?) {
        self.targetedHighlightPreviewProvider = provider
    }
    
    mutating func addDismissPreview(_ provider: @escaping ()->UITargetedPreview?) {
        self.targetedDismissPreviewProvider = provider
    }
    
    mutating func addPresentHandler(_ handler: @escaping ()->()) {
        self.willPresent = handler
    }
    
    mutating func addDismissHandler(_ handler: @escaping ()->()) {
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
    var previewCommitter: ((UIViewController?)->())?
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
