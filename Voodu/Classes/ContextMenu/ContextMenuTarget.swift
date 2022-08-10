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
    
    func addContextMenu(_ contextMenu: ContextMenu) -> ContextMenuInteraction {
                
        if let existingInteraction = self.interactions.first(where: { $0 is UIContextMenuInteraction }) {
            removeInteraction(existingInteraction)
        }
                        
        let interaction = UIContextMenuInteraction(delegate: contextMenu)
        
        contextMenu.interaction = interaction
        
        addInteraction(interaction)
        
        return contextMenu
        
    }
    
    func addContextMenu(provider: @escaping ContextMenu.Provider) -> ContextMenuInteraction {
        
        let contextMenu = ContextMenu(provider: provider)
        return addContextMenu(contextMenu)
        
    }
    
    func removeContextMenu(for interaction: ContextMenuInteraction) {
        
        guard let contextMenu = interaction as? ContextMenu,
              let uiInteraction = contextMenu.interaction else { return }
        
        removeInteraction(uiInteraction)
        
    }
    
}
