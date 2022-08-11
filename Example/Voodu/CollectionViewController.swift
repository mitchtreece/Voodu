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
        count: 10
    )
    .flatMap { $0 }
    .shuffled()

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
        
        self.menuInteraction = ContextMenu { menu in
                                    
            menu.addPreview { data -> UIViewController? in
                
                guard let color = data["color"] as? Color else { return nil }

                let viewController = UIViewController()
                viewController.title = color.name
                viewController.view.backgroundColor = color.color
                viewController.preferredContentSize = CGSize(width: 300, height: 300)

                return viewController
                
            }
            
            menu.addAction { action in
                
                action.title = "Tap the preview to present it"
                action.image = UIImage(systemName: "hand.tap")
                
//                action.handler = { _ in
//
//                    // todo pass data to addAction(..)
//                    // get color and present vc
//
//                }
                
            }
            
        }
        .collectionInteraction()
        
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
        
        let size = (collectionView.bounds.width / 3)
        
        return CGSize(
            width: size,
            height: size
        )
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
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
    
//    override func collectionView(_ collectionView: UICollectionView,
//                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
//                                 point: CGPoint) -> UIContextMenuConfiguration? {
//
//        return self.menuInteraction.configuration(
//            in: collectionView,
//            indexPath: indexPath,
//            point: point
//        )
//
//    }
    
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
