//
//  TreeView.swift
//  SwiftTree
//
//  Created by cronycle on 26/07/2019.
//  Copyright © 2019 Cronycle. All rights reserved.
//

import UIKit

public class NodeView: UIView {
    
    @IBOutlet weak var constraintNodeHeight: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    
    public var node : Node? {
        didSet {
            guard let node = node else {return}
            let filteredString = node.displayText.replacingOccurrences(of: " )", with: "").replacingOccurrences(of: "(", with: "")
            let attributedText = NSMutableAttributedString.init(string:filteredString)
            if node.relationToParent == .not {
                backgroundColor = node.relationToParent.backgroundColor
            } else {
                let color = #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.768627451, alpha: 1)
                attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: NSRange.init(location: 0, length: filteredString.count))
            }
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange.init(location: 0, length: filteredString.count))
            addAttribute(forRelation: .and, toText: attributedText)
            addAttribute(forRelation: .or, toText: attributedText)
            label.attributedText = attributedText
        }
    }
    
    public var nodeHeight : CGFloat = 30.0
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        constraintNodeHeight.constant = nodeHeight
    }
    
    class func instantiate(withOwner owner: Any) -> NodeView {
        let feedsView = UINib.init(nibName: "NodeView", bundle:nil).instantiate(withOwner: owner, options: [:])[0] as! NodeView
        feedsView.clipsToBounds = true
        return feedsView
    }
}

extension NodeView {
    func addAttribute(forRelation relation : Relation, toText text : NSMutableAttributedString) {
        let indices : [Int] = text.string.indicesOf(relation.rawValue)
        for index in indices {
            let rangeOfRelation = NSRange.init(location: index, length: relation.rawValue.count)
            let color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            text.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: rangeOfRelation)
        }
    }
}
