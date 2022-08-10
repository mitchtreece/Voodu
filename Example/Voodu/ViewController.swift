//
//  ViewController.swift
//  Voodu
//
//  Created by Mitch Treece on 8/8/22.
//  Copyright (c) 2022 Mitch Treece. All rights reserved.

import UIKit
import Voodu

class ViewController: UIViewController {
    
    @IBOutlet private weak var optionsBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var optionsView: UIView!
    @IBOutlet private weak var optionsButton: UIButton!
    @IBOutlet private weak var listsButton: UIButton!

    private var optionsViewInteraction: ContextMenuInteraction!
    private var optionsItemInteraction: MenuInteraction!
    private var optionsButtonInteraction: MenuInteraction!
    private var listsButtonInteraction: MenuInteraction!
    
    private var isShared: Bool = false
    private var isFavorite: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupMenus()
        
    }
    
    private func setupMenus() {
        
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
                action.image = self.isShared ? nil : UIImage(systemName: "square.and.arrow.up")
                action.state = self.isShared ? .on : .off

                action.handler = { _ in
                    self.isShared.toggle()
                }

            }

        }

        if #available(iOS 14, *) {
            
            // Share Bar Button Item
            
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
                    action.image = self.isShared ? nil : UIImage(systemName: "square.and.arrow.up")
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
                    action.image = self.isShared ? nil : UIImage(systemName: "square.and.arrow.up")
                    action.state = self.isShared ? .on : .off

                    action.handler = { _ in
                        self.isShared.toggle()
                    }

                }

            }

            // Lists Button

            self.listsButton.showsMenuAsPrimaryAction = true

            self.listsButtonInteraction = self.listsButton.addMenu { [weak self] menu in


                guard let self = self else { return }

                menu.addAction { action in

                    action.title = "Table"
                    action.image = UIImage(systemName: "list.dash")

                    action.handler = { _ in
                        self.didTapTable()
                    }

                }

                menu.addAction { action in

                    action.title = "Collection"
                    action.image = UIImage(systemName: "tablecells")

                    action.handler = { _ in
                        self.didTapCollection()
                    }

                }

            }

        }
        
    }
    
    private func didTapTable() {
        
    }
    
    private func didTapCollection() {
        
    }
    
}
