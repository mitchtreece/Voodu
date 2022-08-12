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
    
    private let itemsPerRow: Int = 6
    private let itemSpacing: CGFloat = 8

    private var menuInteraction: ContextMenuCollectionInteraction!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMenu()
        
        self.collectionView!.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        
    }
    
    private func setupMenu() {
        
        self.menuInteraction = ContextMenu { [weak self] data, menu in
                           
            guard let indexPath = data.getIndexPath() else { return }
            
            menu.addAction { action in
                
                action.title = "Tap the preview to present it"
                action.image = UIImage(systemName: "hand.tap")
                
                action.handler = { _ in
                    self?.presentItemAtIndexPath(indexPath)
                }
                
            }
            
            menu.addPreview {
                
                guard let color = data["color"] as? Color else { return nil }
   
                let previewViewController = self?.buildDetailViewController(color: color)
                previewViewController?.preferredContentSize = CGSize(width: 300, height: 300)
                return previewViewController
                
            }
            
            menu.addPreviewCommitter { vc in
                self?.presentItemAtIndexPath(indexPath)
            }
            
        }
        .collectionInteraction()
        
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
        
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            )
        
        cell.contentView.backgroundColor = color.color
        
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
        
        return self.menuInteraction
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
        
        self.menuInteraction.willDisplay(
            in: collectionView,
            configuration: configuration,
            animator: animator
        )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                                 animator: UIContextMenuInteractionAnimating?) {
        
        self.menuInteraction.willEnd(
            in: collectionView,
            configuration: configuration,
            animator: animator
        )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfiguration configuration: UIContextMenuConfiguration,
                                 highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        
        return self.menuInteraction.highlightingPreview(
            in: collectionView,
            configuration: configuration
        )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfiguration configuration: UIContextMenuConfiguration,
                                 dismissalPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        
        self.menuInteraction.dismissingPreview(
            in: collectionView,
            configuration: configuration
        )
        
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                 animator: UIContextMenuInteractionCommitAnimating) {
        
        self.menuInteraction.willPerformPreviewAction(
            in: collectionView,
            configuration: configuration,
            animator: animator
        )
        
    }
    
}
