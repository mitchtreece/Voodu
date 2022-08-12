//
//  ContextMenuTarget.swift
//  Menus
//
//  Created by Mitch Treece on 8/8/22.
//

import UIKit

public protocol ContextMenuTarget {
    
    var interactions: [UIInteraction] { get }
    
    func addInteraction(_ interaction: UIInteraction)
    func removeInteraction(_ interaction: UIInteraction)
    
}

extension UIView: ContextMenuTarget {}

public extension ContextMenuTarget {
    
    func addContextMenu(_ contextMenu: ContextMenu) {
                
        if let existingInteraction = self.interactions.first(where: { $0 is UIContextMenuInteraction }) {
            removeInteraction(existingInteraction)
        }
                                        
        let interaction = contextMenu.setupContextMenuInteraction()
        addInteraction(interaction)
        
    }
    
    func addContextMenu(provider: @escaping ContextMenu.Provider) -> ContextMenu {
        
        let contextMenu = ContextMenu(provider: provider)
        addContextMenu(contextMenu)
        
        return contextMenu
        
    }
    
    func removeContextMenu(_ contextMenu: ContextMenu) {
        
        guard let interaction = contextMenu.contextMenuInteraction,
              let view = self as? UIView,
              interaction.view == view else { return }
        
        removeInteraction(interaction)
        
    }

}
