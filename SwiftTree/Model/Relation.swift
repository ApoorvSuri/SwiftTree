//
//  Relation.swift
//  SwiftTree
//
//  Created by cronycle on 26/07/2019.
//  Copyright © 2019 Cronycle. All rights reserved.
//

import UIKit

public enum Relation : String {
    case and = "AND"
    case or = "OR"
    case not = "NOT"
    
    var backgroundColor : UIColor {
        get {
            switch self {
            case .and,.or:
                return #colorLiteral(red: 0.9843137255, green: 0.7843137255, blue: 0.2470588235, alpha: 1)
            default:
                return #colorLiteral(red: 0.8823529412, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            }
        }
    }
}
