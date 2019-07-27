//
//  TreeView.swift
//  SwiftTree
//
//  Created by cronycle on 27/07/2019.
//  Copyright © 2019 Cronycle. All rights reserved.
//

import UIKit

public class TreeView: UIScrollView {
    
    var text : String!
    
    public var xMultiplier : CGFloat = 80
    public var yMultiplier : CGFloat = 60
    
    public var initialX : CGFloat = 15
    public var initialY : CGFloat = 15
    
    public var nodeCornerRadius : CGFloat = 10
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let node = Node.init(value: text, parent: nil)
        layoutNodes(node: node)
    }
    
    public init(withText string : String, frame : CGRect) {
        text = string
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func label(forNode node : Node,cornerRadius : CGFloat = 10) -> NodeView {
        let view : NodeView = NodeView.instantiate(withOwner: self)
        view.node = node
        return view
    }
}

extension TreeView {
    func layoutNodes(node : Node){
        layoutNode(node: node)
        layoutSubNodes(forNode: node, prevX: initialX + xMultiplier, prevY: initialY + yMultiplier)
        plotRelations(forNode: node)
        configureContentSize()
    }
    
    func layoutSubNodes(forNode node : Node, prevX : CGFloat = 15, prevY : CGFloat = 15) {
        var newY = prevY
        for subNode in node.children {
            layoutNode(node: subNode, prevX: prevX, prevY: newY)
            if subNode.children.count > 0 {
                layoutSubNodes(forNode: subNode, prevX: prevX + xMultiplier, prevY: newY + yMultiplier)
            }
            newY += CGFloat(subNode.height * Int(yMultiplier)) + yMultiplier
        }
    }
    
    func layoutNode(node : Node, prevX : CGFloat = 15, prevY : CGFloat = 15) {
        let lbl = label(forNode: node,cornerRadius: nodeCornerRadius)
        lbl.label.sizeToFit()
        let width : CGFloat = lbl.label.frame.size.width + 20
        lbl.frame = CGRect.init(x: prevX, y: prevY, width: width, height: 30)
        addSubview(lbl)
    }
    
    func configureContentSize(){
        let maxX : CGFloat = (subviews.sorted(by: {$0.frame.maxX > $1.frame.maxX}).first?.frame.maxX ?? 0.0) + 10.0
        let maxY : CGFloat = (subviews.sorted(by: {$0.frame.maxY > $1.frame.maxY}).first?.frame.maxY ?? 0.0) + 10.0
        contentSize = CGSize.init(width: max(maxX, contentSize.width), height: max(maxY, contentSize.height))
    }
}


extension TreeView {
    func plotRelations(forNode node : Node)  {
        if node.children.count > 0 {
            if let parentView = subviews.first(where: {($0 as? NodeView)?.node == node}) as? NodeView {
                for i in 0...node.children.count-1 {
                    // Plot the relations
                    if let viewForChild = subviews.first(where: {($0 as? NodeView)?.node == node.children[i]}) as? NodeView {
                        let relationView = RelationView.init(withType: viewForChild.node?.relationToParent ?? .and)
                        let frame = CGRect.init(x: viewForChild.frame.origin.x - xMultiplier, y: viewForChild.frame.origin.y, width: xMultiplier, height: 16)
                        relationView.frame = frame
                        if viewForChild.node?.parent?.relationToParent == .not {
                            relationView.subviews[0].backgroundColor = Relation.not.backgroundColor
                        }
                        addSubview(relationView)
                        // Drawing left and right lines
                        relationView.configureLines(containerView: self)

                        /*
                         If the current node is the last child, connect the dots with a verical child
                         */
                        if i == node.children.count - 1 {
                            // If it is the last node draw the vertical line
                            let dottedLine = CGPoint.dottedLine(forType: .verticalDots)
                            let p0 = CGPoint.init(x: parentView.frame.origin.x + 10, y: parentView.frame.origin.y + parentView.bounds.size.height)
                            let p1 = CGPoint.init(x: viewForChild.frame.origin.x - xMultiplier, y: viewForChild.frame.origin.y + viewForChild.frame.height/2)
                            dottedLine.frame = CGRect.init(x: p0.x, y: p0.y, width: 1, height: p1.y - p0.y)
                            addSubview(dottedLine)
                        }
                    }
                    if node.children[i].children.count > 0 {
                        plotRelations(forNode: node.children[i])
                    }
                }
            }
        }
    }
}
