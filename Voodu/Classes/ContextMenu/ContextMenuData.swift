//
//  ContextMenuData.swift
//  Voodu
//
//  Created by Mitch Treece on 8/11/22.
//

import Foundation

public struct ContextMenuData {
    
    public subscript(key: String) -> Any? {
        get {
            return get(key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    private var data = [String: Any]()
    
    public func get(_ key: String) -> Any? {
        return self.data[key]
    }
    
    public mutating func set(_ value: Any?,
                             forKey key: String) {
        
        self.data[key] = value
        
    }
    
    // MARK: Helpers
    
    public func indexPath() -> IndexPath? {
        return get("indexPath") as? IndexPath
    }
    
    public func tableCell() -> UITableViewCell? {
        return get("cell") as? UITableViewCell
    }
    
    public func collectionCell() -> UICollectionViewCell? {
        return get("cell") as? UICollectionViewCell
    }
    
}
