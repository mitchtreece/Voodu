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

    private var optionsViewMenu: ContextMenu!
    private var optionsItemMenu: Menu!
    private var optionsButtonMenu: Menu!
    private var listsButtonMenu: Menu!
        
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
        
        self.optionsViewMenu = self.optionsView.addContextMenu { [weak self] data, menu in

            guard let strongSelf = self else { return }
            
            let isFavorite = strongSelf.isFavorite
            let isShared = strongSelf.isShared

            menu.addAction { action in

                action.title = isFavorite ? "Remove favorite" : "Add favorite"
                action.image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

                action.handler = { _ in
                    self?.isFavorite.toggle()
                }

            }

            menu.addAction { action in

                action.title = isShared ? "Shared" : "Share"
                action.image = isShared ? UIImage(systemName: "square.and.arrow.up.fill") : UIImage(systemName: "square.and.arrow.up")
                action.state = isShared ? .on : .off

                action.handler = { _ in
                    self?.isShared.toggle()
                }

            }
            
            if #available(iOS 14, *) {
             
                menu.addDeferredElements { completion in
                    
                    let action = UIAction { a in
                        
                        a.title = "Thanks for waiting!"
                        a.image = UIImage(systemName: "clock")
                        
                    }
                                        
                    Task {
                        
                        try! await Task.sleep(nanoseconds: 2000000000)
                        completion([action])
                        
                    }
                    
                }
                
            }

        }
        
        if #available(iOS 14, *) {
            
            self.optionsItemMenu = self.optionsBarButtonItem.addMenu { [weak self] menu in
                
                guard let strongSelf = self else { return }
                
                let isFavorite = strongSelf.isFavorite
                let isShared = strongSelf.isShared
                
                menu.addAction { action in

                    action.title = isFavorite ? "Remove favorite" : "Add favorite"
                    action.image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

                    action.handler = { _ in
                        self?.isFavorite.toggle()
                    }

                }

                menu.addAction { action in

                    action.title = isShared ? "Shared" : "Share"
                    action.image = isShared ? UIImage(systemName: "square.and.arrow.up.fill") : UIImage(systemName: "square.and.arrow.up")
                    action.state = isShared ? .on : .off

                    action.handler = { _ in
                        self?.isShared.toggle()
                    }

                }

            }
            
            // Options Button

            self.optionsButton.showsMenuAsPrimaryAction = true

            self.optionsButtonMenu = self.optionsButton.addMenu { [weak self] menu in

                guard let strongSelf = self else { return }
                
                let isFavorite = strongSelf.isFavorite
                let isShared = strongSelf.isShared
                
                menu.addAction { action in

                    action.title = isFavorite ? "Remove favorite" : "Add favorite"
                    action.image = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")

                    action.handler = { _ in
                        self?.isFavorite.toggle()
                    }

                }

                menu.addAction { action in

                    action.title = isShared ? "Shared" : "Share"
                    action.image = isShared ? UIImage(systemName: "square.and.arrow.up.fill") : UIImage(systemName: "square.and.arrow.up")
                    action.state = isShared ? .on : .off

                    action.handler = { _ in
                        self?.isShared.toggle()
                    }

                }
                
                menu.addAction { action in
                    
                    action.title = "UITableView"
                    
                    if #available(iOS 15, *) {
                        action.subtitle = "ContextMenu example"
                    }

                    action.image = UIImage(systemName: "list.bullet")

                    action.handler = { _ in
                        self?.didTapTable()
                    }
                    
                }
                
                menu.addAction { action in
                    
                    action.title = "UICollectionView"
                    
                    if #available(iOS 15, *) {
                        action.subtitle = "ContextMenu example"
                    }
                    
                    action.image = UIImage(systemName: "tablecells")

                    action.handler = { _ in
                        self?.didTapCollection()
                    }
                    
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
