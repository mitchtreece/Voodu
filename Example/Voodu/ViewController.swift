//
//  ViewController.swift
//  Voodu
//
//  Created by Mitch Treece on 8/8/22.
//  Copyright © 2022 Mitch Treece. All rights reserved.

import UIKit
import Voodu

class ViewController: UIViewController {
    
    @IBOutlet private weak var optionsBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var optionsButton: UIButton!
    @IBOutlet private weak var optionsView: UIView!

    private var optionsViewInteraction: ContextMenuInteraction!
    private var optionsItemInteraction: MenuInteraction!
    private var optionsButtonInteraction: MenuInteraction!
    private var listsButtonInteraction: MenuInteraction!
    
    private var isShared: Bool = false
    private var isFavorite: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupSubviews()
        setupMenus()
        
    }
    
    private func setupSubviews() {
        
        self.optionsView.layer.cornerRadius = 14
        
    }

    private func setupMenus() {

        if #available(iOS 14, *) {
            
            self.optionsItemInteraction = self.optionsBarButtonItem.addMenu { [weak self] menu in

                guard let self = self else { return }
                
                menu.addAction { action in

                    action.title = self.isFavorite ? "Remove favorite" : "Add favorite"
                    action.image = self.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

                    action.handler = { _ in
                        self.isFavorite.toggle()
                    }

                }

                menu.addAction { action in

                    action.title = self.isShared ? "Shared" : "Share"
                    action.image = self.isShared ? UIImage(systemName: "square.and.arrow.up.fill") : UIImage(systemName: "square.and.arrow.up")
                    action.state = self.isShared ? .on : .off

                    action.handler = { _ in
                        self.isShared.toggle()
                    }

                }

            }
            
            // Options Button

            self.optionsButton.showsMenuAsPrimaryAction = true

            self.optionsButtonInteraction = self.optionsButton.addMenu { [weak self] menu in

                guard let self = self else { return }

                menu.addAction { action in

                    action.title = self.isFavorite ? "Remove favorite" : "Add favorite"
                    action.image = self.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

                    action.handler = { _ in
                        self.isFavorite.toggle()
                    }

                }

                menu.addAction { action in

                    action.title = self.isShared ? "Shared" : "Share"
                    action.image = self.isShared ? UIImage(systemName: "square.and.arrow.up.fill") : UIImage(systemName: "square.and.arrow.up")
                    action.state = self.isShared ? .on : .off

                    action.handler = { _ in
                        self.isShared.toggle()
                    }

                }
                
                menu.addAction { action in
                    
                    action.title = "UITableView"
                    
                    if #available(iOS 15, *) {
                        action.subtitle = "ContextMenu example"
                    }

                    action.image = UIImage(systemName: "list.bullet")

                    action.handler = { _ in
                        self.didTapTable()
                    }
                    
                }
                
                menu.addAction { action in
                    
                    action.title = "UICollectionView"
                    
                    if #available(iOS 15, *) {
                        action.subtitle = "ContextMenu example"
                    }
                    
                    action.image = UIImage(systemName: "tablecells")

                    action.handler = { _ in
                        self.didTapCollection()
                    }
                    
                }

            }
            
        }
        
        self.optionsViewInteraction = self.optionsView.addContextMenu { [weak self] menu in

            guard let self = self else { return }

            menu.addAction { action in

                action.title = self.isFavorite ? "Remove favorite" : "Add favorite"
                action.image = self.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

                action.handler = { _ in
                    self.isFavorite.toggle()
                }

            }

            menu.addAction { action in

                action.title = self.isShared ? "Shared" : "Share"
                action.image = self.isShared ? UIImage(systemName: "square.and.arrow.up.fill") : UIImage(systemName: "square.and.arrow.up")
                action.state = self.isShared ? .on : .off

                action.handler = { _ in
                    self.isShared.toggle()
                }

            }

        }
        
    }
    
    private func didTapTable() {
                
        self.navigationController?
            .pushViewController(
                viewControllerWithIdentifier("TableViewController"),
                animated: true
            )
        
    }
    
    private func didTapCollection() {
       
        self.navigationController?
            .pushViewController(
                viewControllerWithIdentifier("CollectionViewController"),
                animated: true
            )
        
    }
    
    private func viewControllerWithIdentifier(_ identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        
        return storyboard
            .instantiateViewController(withIdentifier: identifier)
        
    }
    
}
