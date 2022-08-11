//
//  Color.swift
//  Voodu_Example
//
//  Created by Mitch Treece on 8/10/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

enum Color: String, CaseIterable {
    
    case red
    case orange
    case yellow
    case green
    case blue
    case indigo
    case violet
    
    var name: String {
        return self.rawValue.capitalized
    }
    
    var color: UIColor {
        
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .indigo: return .init(red: 0.3, green: 0, blue: 0.5, alpha: 1)
        case .violet: return .init(red: 0.93, green: 0.51, blue: 0.93, alpha: 1)
        }
        
    }
    
}
