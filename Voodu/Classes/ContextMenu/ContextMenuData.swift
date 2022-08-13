//
//  ContextMenuData.swift
//  Voodu
//
//  Created by Mitch Treece on 8/11/22.
//

import Foundation

/// A context menu data container.
public struct ContextMenuData {
    
    internal static let indexPathKey = "voodu_index_path"
    internal static let tableCellKey = "voodu_table_cell"
    internal static let collectionCellKey = "voodu_collection_cell"

    public subscript(key: String) -> Any? {
        get {
            return get(key)
        }
        set {
            set(newValue, forKey: key)
        }
    }
    
    private var data = [String: Any]()
    
    /// Sets a piece data for a given key.
    ///
    /// - parameter data: The data.
    /// - parameter key: The key to associate the data to.
    public mutating func set(_ value: Any?,
                             forKey key: String) {
        
        self.data[key] = value
        
    }
    
    /// Retrieves a piece of data associated with a given key.
    ///
    /// - parameter key: The associated data's key.
    /// - returns: The associated data.
    public func get(_ key: String) -> Any? {
        return self.data[key]
    }
    
    // MARK: Helpers
    
    /// Retrieves the stored index path.
    ///
    /// - returns: An `IndexPath`.
    public func indexPath() -> IndexPath? {
        return get(Self.indexPathKey) as? IndexPath
    }
    
    /// Retrieves the stored table cell.
    ///
    /// - returns: A `UITableViewCell`.
    public func tableCell() -> UITableViewCell? {
        return get(Self.tableCellKey) as? UITableViewCell
    }
    
    /// Retrieves the stored collection cell.
    ///
    /// - returns: A `UICollectionViewCell`.
    public func collectionCell() -> UICollectionViewCell? {
        return get(Self.collectionCellKey) as? UICollectionViewCell
    }
    
}
