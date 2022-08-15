//
//  CollectionViewController.swift
//  Voodu
//
//  Created by Mitch Treece on 8/10/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Voodu

class CollectionViewController: UICollectionViewController {
    
    private let colors: [Color] = Array(
        repeating: Color.allCases,
        count: 30
    )
    .flatMap { $0 }
    .shuffled()
    
    private let itemsPerRow: Int = 5
    private let itemSpacing: CGFloat = 8
    private let itemCornerRadius: CGFloat = 8
    private var addedItemMap = [IndexPath: Bool]()

    private var collectionMenu: ContextMenu!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMenu()
        
        self.collectionView!.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        
    }
    
    private func setupMenu() {
        
        self.collectionMenu = ContextMenu { [weak self] data, menu in
                           
            guard let indexPath = data.indexPath() else { return }
                        
            menu.addAction { action in
                
                let isAdded = self?.addedItemMap[indexPath] ?? false
                                
                action.title = isAdded ? "Remove" : "Add"
                action.image = UIImage(systemName: isAdded ? "minus.circle" : "plus.circle")
                action.attributes = isAdded ? .destructive : []
                
                action.handler = { _ in
                    self?.addOrRemoveAt(indexPath: indexPath)
                }
                
            }
            
            menu.addPreview {
                
                guard let color = data["color"] as? Color else { return nil }
   
                let previewViewController = self?.buildDetailViewController(color: color)
                previewViewController?.preferredContentSize = CGSize(width: 300, height: 300)
                return previewViewController
                
            }
            
            menu.addHighlightPreview {

                guard let cell = data.collectionCell() else { return nil }

                let parameters = UIPreviewParameters()
                
                parameters.visiblePath = UIBezierPath(
                    roundedRect: cell.contentView.frame,
                    cornerRadius: self?.itemCornerRadius ?? 0
                )

                return UITargetedPreview(
                    view: cell,
                    parameters: parameters
                )

            }
            
            menu.addPreviewAction { vc in
                self?.presentItemAtIndexPath(indexPath)
            }
            
        }
        
    }
    
    private func addOrRemoveAt(indexPath: IndexPath) {
        
        let isAdded = self.addedItemMap[indexPath] ?? false
        self.addedItemMap[indexPath] = !isAdded
        
        self.collectionView!
            .reloadItems(at: [indexPath])
        
    }
    
    private func presentItemAtIndexPath(_ indexPath: IndexPath) {
        
        let color = self.colors[indexPath.row]
        let vc = buildDetailViewController(color: color)
        
        self.navigationController?
            .pushViewController(
                vc,
                animated: true
            )
        
    }
    
    private func buildDetailViewController(color: Color) -> UIViewController {
        
        let viewController = UIViewController()
        viewController.title = color.name
        viewController.view.backgroundColor = color.color
        return viewController
        
    }
    
}

// MARK: UICollectionView

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return self.colors.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing = CGFloat(self.itemsPerRow - 1) * self.itemSpacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        let size = floor(availableWidth / CGFloat(self.itemsPerRow))
        
        return CGSize(
            width: size,
            height: size
        )
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.itemSpacing
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return self.itemSpacing
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let color = self.colors[indexPath.item]
        let isAdded = self.addedItemMap[indexPath] ?? false
        
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            )
        
        cell.contentView.backgroundColor = color.color
        cell.contentView.layer.cornerRadius = self.itemCornerRadius
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.contentView.layer.borderWidth = isAdded ? 12 : 0
                
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        presentItemAtIndexPath(indexPath)
        
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let indexPath = indexPaths.first else { return nil }
        
        let color = self.colors[indexPath.row]
        
        return self.collectionMenu
            .asCollectionInteraction()
            .setData(color, forKey: "color")
            .configuration(
                in: collectionView,
                indexPath: indexPath,
                point: point
            )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplayContextMenu configuration: UIContextMenuConfiguration,
                                 animator: UIContextMenuInteractionAnimating?) {
        
        self.collectionMenu
            .asCollectionInteraction()
            .willDisplay(
                in: collectionView,
                configuration: configuration,
                animator: animator
            )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                                 animator: UIContextMenuInteractionAnimating?) {
        
        self.collectionMenu
            .asCollectionInteraction()
            .willEnd(
                in: collectionView,
                configuration: configuration,
                animator: animator
            )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfiguration configuration: UIContextMenuConfiguration,
                                 highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        
        return self.collectionMenu
            .asCollectionInteraction()
            .highlightPreview(
                in: collectionView,
                configuration: configuration
            )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfiguration configuration: UIContextMenuConfiguration,
                                 dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        
        self.collectionMenu
            .asCollectionInteraction()
            .dismissPreview(
                in: collectionView,
                configuration: configuration
            )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                 animator: UIContextMenuInteractionCommitAnimating) {
        
        self.collectionMenu
            .asCollectionInteraction()
            .willPerformPreviewAction(
                in: collectionView,
                configuration: configuration,
                animator: animator
            )
        
    }
    
}
