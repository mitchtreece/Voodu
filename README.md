![Voodu](Assets/Banner.png)

<div align="center">

![Version](https://img.shields.io/badge/Version-1.0.0-A99CCF.svg?style=for-the-badge&labelColor=806BBA)
![iOS](https://img.shields.io/badge/iOS-13+-A99CCF.svg?style=for-the-badge&labelColor=806BBA)
![Swift](https://img.shields.io/badge/Swift-5-A99CCF.svg?style=for-the-badge&labelColor=806BBA)
![Xcode](https://img.shields.io/badge/Xcode-14-A99CCF.svg?style=for-the-badge&labelColor=806BBA)

Swift context menu library for iOS. Powered by magic 🪄

</div>

# Voodu

## ⚠️ iOS 16 & Xcode 14

**This library uses the iOS 16 toolchain, and therefore requires Xcode 14**

## Installation

### SPM

```
.package(url: "https://github.com/mitchtreece/Voodu.git", .upToNextMajor(from: "1.0.0"))
```

### CocoaPods

```
use_frameworks!
pod 'Voodu', '~> 1.0'
```

## Usage

### UIMenu & UIAction

One of the core components when creating any menu, is the creation of actions, menus, & sub-menus. On iOS, these are represented via `UIAction` & `UIMenu`. Even without taking advantage of Voodu's other powerful menu building options, you can utilize helpers on these two classes for simple, fluid initialization.

```swift

let action = UIAction { action in

    action.title = "Tap me, I'm an action!"
    action.image = UIImage(systemName: "hand.tap")

    action.handler { _ in
        print("You tapped the action")
    }

}

let menu = UIMenu { menu in

    menu.title = "Hello, Im a menu!"
    
    menu.addAction { action in
    
        action.title = "Tap me, I'm a menu action!"

        action.handler = { _ in
            print("You tapped the menu action!")
        }
    
    }

    menu.addMenu { submenu in
    
        submenu.title = "Hello, I'm a submenu!"
        submenu.image = UIImage(systemName: "star")

        submenu.addAction { action in
        
            action.title = "Tap me, I'm a submenu action!"

            action.handler = { _ in
                print("You tapped the menu action!")
            }

        }

    }

}
```

### Menus

What good is creating a `UIMenu` if we don't show it to the user? Typically, this would be done by attaching the menu to a supported UI component (i.e. `UIButton` or `UIBarButtonItem`). However, there are some weird quirks when doing this using the standard `UIKit` API's. Namely, when needing to update or react to user interaction. With standard `UIKit`, menus need to be created & re-attached to a UI component **every time** you want a menu to update or change the state of one of its elements. Seems kind of tedious right? It is, and that's where the magic of Voodu's `Menu` comes to the rescue.

```swift

var button = UIButton()
var buttonMenu: Menu!

...

self.buttonMenu = Menu { menu in
    
    menu.addAction { action in
    
        action.title = "Tap me, I'm a menu action!"

        action.handler = { _ in
            print("You tapped the menu action!")
        }
    
    }

    menu.addMenu { submenu in
    
        submenu.title = "Hello, I'm a submenu!"
        submenu.image = UIImage(systemName: "star")

        submenu.addAction { action in
        
            action.title = "Tap me, I'm a submenu action!"

            action.handler = { _ in
                print("You tapped the menu action!")
            }

        }

    }

}

self.button
    .addMenu(self.buttonMenu)
```

And that's it! The menu's closure will be called whenever it needs to be displayed; meaning any updates that need to be reflected to the user will just automatically happen 🎉🙌🏼. For example, say we want to allow the user to add/remove the item a menu represents as a "favorite". The implementation for this might look like:

```swift

var button = UIButton()
var buttonMenu = Menu!
var isFavorite: Bool = false

...

self.buttonMenu = self.button.addMenu { [weak self] menu in

    guard let strongSelf = self else { return }

    let isFavorite = strongSelf.isFavorite

    menu.addAction { action in
    
        action.title = isFavorite ? "Remove favorite" : "Add favorite"
        action.image = isFavorite ? UIImage(systemName: "trash") : UIImage(systemName: "star")
        action.attributes = isFavorite ? .destructive : []

        action.handler = { _ in
            self?.isFavorite.toggle()
        }

    }

}
```

Nice and simple, just how it should be 😎

#### Interactions

Most of the time, you don't need to do anything else. However, there are some circumstances where you want to manually interact with a presented `Menu`. To do this, we access the menu's `MenuInteraction` to, for example, update or dismiss a visible menu.

```swift

self.buttonMenu
    .asInteraction()
    .updateVisible { 
        ... 
    }

self.buttonMenu
    .asInteraction()
    .dismiss()

```

**Note**: `Menu` & `MenuInteraction` **do not** keep a strong reference to it's underlying component. You **must** keep a reference to any created menu yourself - otherwise it will be released.

### Context Menus

Contextual (preview) menus are becoming more and more a staple interaction with each new release of iOS. However, like `Menu`, the standard `UIKit` API's leave something to be desired when working with them. If you've tried implementing them yourself, you're probably familiar with `UIContextMenuInteraction` & `UIContextMenuInteractionDelegate`. Even just looking at those long winded names give me a headache - let alone thinking about implementing them. As with before, Voodu's `ContextMenu` can drastically simplify adding this functionality to your apps.

```swift
var view = UIView()
var viewMenu: ContextMenu!

...

self.viewMenu = self.view.addContextMenu { _, menu in

    menu.addAction { action in
    
        action.title = "Tap me, I'm a context menu action!"

        action.handler = { _ in
            print("You tapped the context menu action!")
        }
    
    }

}
```

The semantics for `ContextMenu` are the same as `Menu`, with the addition of configurable data & preview-specific properties and helpers. By default, a system-generated preview will be provided for the view presenting the context menu. If you want to customize this behavior, you can specify a custom preview provider, targeted previews, & a preview action handler.

```swift
var view = UIView()
var viewMenu: ContextMenu!

func didTapPreview(_ vc: UIViewController?) {

    guard let vc = vc else { return }

    self.navigationController?
        .push(vc, animated: true)

}

...

self.viewMenu = self.view.addContextMenu { _, menu in

    menu.addAction { action in
    
        action.title = "Tap me, I'm a context menu action!"

        action.handler = { _ in
            print("You tapped the context menu action!")
        }
    
    }

    menu.addPreview {

        let previewViewController = UIViewController()
        previewViewController.view.backgroundColor = .red
        previewViewController.preferredContentSize = CGSize(width: 300, height: 300)
        return previewViewController

    }

    menu.addPreviewAction { [weak self] previewViewController in
        self?.didTapPreview(previewViewController)
    }

    menu.addHighlightPreview {
        ...
    }

    menu.addDismissPreview {
        ...
    }

}
```

#### Table & Collection Interactions

Context menus are often presented from table & collection cells. Again, the standard `UIKit` setup for this functionality is rather annoying. Luckily, `ContextMenu` was built with this functionality in mind. Just like `Menu`, `ContextMenu` has a `ContextMenuInteraction` that can be used when you need to directly interact with a visible menu. However, `ContextMenu` also has `ContextMenuTableInteraction` & `ContextMenuCollectionInteraction` variants that make it a lot more streamlined when trying to implement this sort of functionality.

```swift
var tableMenu: ContextMenu!

...

self.tableMenu = ContextMenu { data, menu in

    let indexPath = data.indexPath() ?? .zero

    menu.addAction { action in
    
        action.title = "Tap me, I'm a table cell action!"

        action.handler = { _ in
            print("You tapped the table cell action at index path: \(indexPath)!")
        }
    
    }

}

...

override func tableView(_ tableView: UITableView,
                        contextMenuConfigurationForRowAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
    return self.tableMenu
        .asTableInteraction()
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
```

Still a little verbose, but unfortunately with how `UIKit` handles table & collection delegates, this is the best we can do. Note the use of the `data` variable passed into the context menu's closure. By default, when using a `ContextMenu` table or collection interaction, the index path & cell are automatically added to the menu's data container. They can be retrieved by calling the one of the container's helper functions: `data.indexPath()` or `data.cell()`.

### Shortcut Menus

The simplest and least convoluted of all menus created with standard `UIKit` API's, application shortcut items (`UIApplicationShortcutItem`) really don't have any weird quirks that needed to be solved. However, to bring shortcut item creation in line with the other menu semantics, helpers have been added for good measure 😄

```swift
UIApplication.shared.addShortcutMenu { menu in

    menu.addItem { item in
        
        item.identifier = "shortcut_item_1"
        item.title = "This is a shortcut item"
        item.image = .init(systemImageName: "1.circle")
        
    }

    menu.addItem { item in
        
        item.identifier = "shortcut_item_2"
        item.title = "This is another one"
        item.image = .init(systemImageName: "2.circle")

    }

}
```

Handling of these shortcut actions is done the same as before via `UIApplicationDelegate` (or `UIWindowSceneDelegate`) functions.

## Contributing

Pull-requests are more than welcome. Bug fix? Feature? Open a PR and we'll get it merged in!