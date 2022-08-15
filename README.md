![Voodu](Assets/Banner.png)

# Voodu

![iOS](https://img.shields.io/badge/iOS-13+-green.svg?style=for-the-badge)
![Swift](https://img.shields.io/badge/Swift-5-orange.svg?style=for-the-badge)
![SPM](https://img.shields.io/badge/SPM-1.0.0-orange.svg?style=for-the-badge)
[![Cocoapods](https://img.shields.io/cocoapods/v/Voodu.svg?style=for-the-badge)](https://cocoapods.org/pods/Voodu)
[![License](https://img.shields.io/cocoapods/l/Voodu.svg?style=for-the-badge)](https://cocoapods.org/pods/Voodu)

Voodu is a Swift context menu library for iOS. Powered by magic 🪄
TODO: Quick blurb about menus on iOS, and how Voodu simplifies working with them

## Installation

### SPM

TODO

### CocoaPods

Voodu is integrated with CocoaPods!

1. Add the following to your `Podfile`:

```
use_frameworks!
pod 'Voodu', '~> 1.0'
```

2. In your project directory, run `pod install`
3. Import the `Voodu` module wherever you need it
4. Profit

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

**Note**: `Menu` **does not** keep a strong reference to it's underlying components. You **must** keep a reference to any created menu yourself - otherwise it will be released.

### Context Menus

Contextual (preview) menus are becoming more and more a staple interaction with each new release of iOS. However, like `Menu`, the standard `UIKit` API's leave something to be desired when working with them. If you've tried implementing them yourself, you're probably familiar with `UIContextMenuInteraction` & `UIContextMenuInteractionDelegate`. Even just looking at those long winded names give me a headache - let alone thinking about implementing them. As with before, Voodu's `ContextMenu` can drastically simplify adding this functionality to your apps.

```swift
var view = UIView()
var viewMenu: ContextMenu!

...

self.viewMenu = self.view.addContextMenu { menu in

    menu.addAction { action in
    
        action.title = "Tap me, I'm a context menu action!"

        action.handler = { _ in
            print("You tapped the context menu action!")
        }
    
    }

}
```

The semantics for `ContextMenu` are the same as `Menu`, with the addition of preview-specific properties & helpers. By default, a system-generated preview will be provided for the view presenting the context menu. If you want to customize this behavior, you can specify a custom preview provider, targeted previews, & a preview action handler.

```swift
var view = UIView()
var viewMenu: ContextMenu!

func didTapPreview(_ vc: UIViewController?) {

    guard let vc = vc else { return }

    self.navigationController?
        .push(vc, animated: true)

}

...

self.viewMenu = self.view.addContextMenu { menu in

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

TODO

### Shortcut Menus

TODO

## Contributing

Pull-requests are more than welcome. Bug fix? Feature? Open a PR and we'll get it merged in!