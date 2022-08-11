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
    var previewProvider: ContextMenu.PreviewProvider? { get set }
    var previewCommitter: ContextMenu.PreviewCommitter? { get set }
    var previewCommitStyle: UIContextMenuInteractionCommitStyle { get set }
    var targetedHighlightPreviewProvider: ContextMenu.TargetedPreviewProvider? { get set }
    var targetedDismissPreviewProvider: ContextMenu.TargetedPreviewProvider? { get set }
    var includeSuggestedElements: Bool { get set }
    var willPresent: (()->())? { get set }
    var willDismiss: (()->())? { get set }

    @available(iOS 16, *)
    var elementSize: UIMenu.ElementSize { get set }
    
}

public extension ContextMenuBuildable {
    
    mutating func addPreview(_ provider: @escaping ContextMenu.PreviewProvider) {
        self.previewProvider = provider
    }
    
    mutating func addPreviewCommitter(_ committer: @escaping ContextMenu.PreviewCommitter) {
        self.previewCommitter = committer
    }
    
    mutating func addHighlightingPreview(_ provider: @escaping ContextMenu.TargetedPreviewProvider) {
        self.targetedHighlightPreviewProvider = provider
    }
    
    mutating func addDismissingPreview(_ provider: @escaping ContextMenu.TargetedPreviewProvider) {
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
    var previewProvider: ContextMenu.PreviewProvider?
    var previewCommitter: ContextMenu.PreviewCommitter?
    var previewCommitStyle: UIContextMenuInteractionCommitStyle = .pop
    var targetedHighlightPreviewProvider: ContextMenu.TargetedPreviewProvider?
    var targetedDismissPreviewProvider: ContextMenu.TargetedPreviewProvider?
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
