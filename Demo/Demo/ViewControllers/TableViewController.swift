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
    
    private var addedItemMap = [IndexPath: Bool]()

    private var tableMenu: ContextMenu!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupMenu()
        
        self.tableView!.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        
    }
    
    private func setupMenu() {
        
        self.tableMenu = ContextMenu { [weak self] data, menu in
                  
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
            
            menu.addPreviewAction { vc in
                self?.presentItemAtIndexPath(indexPath)
            }
            
        }
        
    }
    
    private func addOrRemoveAt(indexPath: IndexPath) {
        
        let isAdded = self.addedItemMap[indexPath] ?? false
        self.addedItemMap[indexPath] = !isAdded
        
        self.tableView.reloadRows(
            at: [indexPath],
            with: .automatic
        )
        
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
        let isAdded = self.addedItemMap[indexPath] ?? false
        
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            )
        
        cell.backgroundColor = isAdded ? .systemGray4 : .systemBackground
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
        
        presentItemAtIndexPath(indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        
        let color = self.colors[indexPath.row]
        
        return self.tableMenu
            .asTableInteraction()
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
        
        self.tableMenu
            .asTableInteraction()
            .willDisplay(
                in: tableView,
                configuration: configuration,
                animator: animator
            )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionAnimating?) {
        
        self.tableMenu
            .asTableInteraction()
            .willEnd(
                in: tableView,
                configuration: configuration,
                animator: animator
            )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return self.tableMenu
            .asTableInteraction()
            .highlightPreview(
                in: tableView,
                configuration: configuration
            )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return self.tableMenu
            .asTableInteraction()
            .dismissPreview(
                in: tableView,
                configuration: configuration
            )
        
    }
    
    override func tableView(_ tableView: UITableView,
                            willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                            animator: UIContextMenuInteractionCommitAnimating) {
        
        self.tableMenu
            .asTableInteraction()
            .willPerformPreviewAction(
                in: tableView,
                configuration: configuration,
                animator: animator
            )
        
    }
    
}
