//
//  TableViewController.swift
//  Voodu
//
//  Created by Mitch Treece on 8/10/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Voodu

class TableViewController: UITableViewController {
    
    private let colors: [Color] = Array(
        repeating: Color.allCases,
        count: 10
    )
    .flatMap { $0 }
    .shuffled()

    private var menuInteraction: ContextMenuTableInteraction!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMenu()
        
        self.tableView!.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
    }
    
    private func setupMenu() {
        
        self.menuInteraction = ContextMenu { [weak self] menu in
            
            menu.addPreviewCommitter { data, vc in
                
                guard let color = data["color"] as? Color else { return }
                self?.presentColor(color)
                
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
        .tableInteraction()
        
    }
    
    private func presentColor(_ color: Color) {
        
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

// MARK: UITableView

extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return self.colors.count
        
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let color = self.colors[indexPath.row]
                
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            )
        
        cell.textLabel?.text = color.name
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
        
        let color = self.colors[indexPath.row]
        presentColor(color)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        
        let color = self.colors[indexPath.row]
        
        return self.menuInteraction
            .setData(color, forKey: "color")
            .configuration(
                in: tableView,
                indexPath: indexPath,
                point: point
            )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayContextMenu configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionAnimating?) {
        
        self.menuInteraction.willDisplay(
            in: tableView,
            configuration: configuration,
            animator: animator
        )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionAnimating?) {
        
        self.menuInteraction.willEnd(
            in: tableView,
            configuration: configuration,
            animator: animator
        )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return self.menuInteraction.highlightingPreview(
            in: tableView,
            configuration: configuration
        )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return self.menuInteraction.dismissingPreview(
            in: tableView,
            configuration: configuration
        )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionCommitAnimating) {
        
        self.menuInteraction.willPerformPreviewAction(
            in: tableView,
            configuration: configuration,
            animator: animator
        )
        
    }
    
}
