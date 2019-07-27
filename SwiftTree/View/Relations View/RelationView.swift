//
//  RelationView.swift
//  SwiftTree
//
//  Created by cronycle on 26/07/2019.
//  Copyright © 2019 Cronycle. All rights reserved.
//

import UIKit
/*
 Override this class to make changes to the Relations i.e. AND, OR and NOT view
 */
public class RelationView: UIView {
    
    //MARK : Public access iVars
    public var type : Relation!
    public var textColor : UIColor = UIColor.white
    public var cornerRadius : CGFloat = 5
    public var textBackgroundColor : UIColor?
    public var textFont : UIFont?
    
    //MARK : Private access iVars
    private var label : UILabel!
    private var labelY : CGFloat = 15.0
    
    init(withType relation : Relation) {
        type = relation
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        configure()
    }
    
    private func configure(){
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 8, width: 40, height: 16))
        label.layer.cornerRadius = cornerRadius
        label.clipsToBounds = true
        label.font = textFont ?? UIFont.systemFont(ofSize: 12)
        label.textColor = textColor
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = textBackgroundColor ?? type.backgroundColor
        label.text = type.rawValue
        addSubview(label)
    }
    /*
     Override this method to change the format of lines being drawn from left and right
    */
    public func configureLines(containerView view : UIView){
        // Draw line from the left
        let p1 = CGPoint.init(x: 10, y: labelY)
        let p2 = CGPoint.init(x: 20, y: labelY)
        CGPoint.drawLine(p1: p1, p2: p2, onView: view)
        // Draw second line on the right
        let p3 = CGPoint.init(x: label.frame.origin.x + label.bounds.size.width, y: labelY)
        let p4 = CGPoint.init(x: view.bounds.size.width, y: labelY)
        CGPoint.drawLine(p1: p3, p2: p4, onView: view)
    }
}
