//
//  CGPoint.swift
//  SwiftTree
//
//  Created by cronycle on 27/07/2019.
//  Copyright © 2019 Cronycle. All rights reserved.
//

import KebabMenuView

extension CGPoint {
    static func dottedLine(forType menuType : KebabMenuType) -> KebabMenuView {
        let menu = KebabMenuView.init()
        menu.menuType = menuType
        return menu
    }
    static func drawLine(p1 p0: CGPoint, p2 p1: CGPoint, lineHeight : CGFloat = 1, onView view : UIView, lineType : KebabMenuType = .horizontalDots) {
        let dottedView = dottedLine(forType: lineType)
        dottedView.frame = CGRect.init(x: p0.x, y: p0.y, width: CGFloat(p1.x - p0.x), height: lineHeight)
        view.addSubview(dottedView)
    }
}
