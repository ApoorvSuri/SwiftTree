//
//  KebabMenuView.swift
//  cronycle-ios
//
//  Created by cronycle on 30/10/2018.
//  Copyright © 2018 Cronycle. All rights reserved.
//

import UIKit

public enum KebabMenuType {
    case none
    case single
    case singleWithDots
    case doubleWithDots
    case verticalDots
    case horizontalDots
}

public class KebabMenuView: UIView {

    public var menuType : KebabMenuType = .none
    public var fillColor = #colorLiteral(red: 0.8823529412, green: 0.862745098, blue: 0.831372549, alpha: 1)
    public var strokeColor = #colorLiteral(red: 0.8823529412, green: 0.862745098, blue: 0.831372549, alpha: 1)
    public var dashedBorderLineColor = UIColor.lightGray
    public var dashedBorderLineDashPattern : [NSNumber] = [2,3]

    private var bezierPath : UIBezierPath?
    
    override public func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        let x = bounds.size.width/2

        switch menuType {
        case .single:
            bezierPath = nil
            bezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: bounds.size.width, height:  bounds.size.height), cornerRadius: 2)
            let maskLayer = CAShapeLayer()
            maskLayer.fillColor = fillColor.cgColor
            maskLayer.path = bezierPath!.cgPath
            layer.addSublayer(maskLayer)
            
        case .singleWithDots:
            bezierPath = nil
            addArc(atPoint: CGPoint(x:x,y:bounds.size.height - 5))
            addArc(atPoint: CGPoint(x:x,y:bounds.size.height - 10))
            addArc(atPoint: CGPoint(x:x,y:bounds.size.height - 15))
            bezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y:  0 , width: bounds.size.width, height:  bounds.size.height - 20), cornerRadius: 2)
            let maskLayer = CAShapeLayer()
            maskLayer.fillColor = fillColor.cgColor
            maskLayer.path = bezierPath!.cgPath
            layer.addSublayer(maskLayer)
            
        case .doubleWithDots:
            bezierPath = UIBezierPath.init()
            bezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y:  0 , width: bounds.size.width, height:  bounds.size.height - 30), cornerRadius: 2)
            let maskLayer = CAShapeLayer()
            maskLayer.fillColor = fillColor.cgColor
            maskLayer.path = bezierPath!.cgPath
            layer.addSublayer(maskLayer)
            addArc(atPoint: CGPoint(x:x,y:bounds.size.height - 15))
            addArc(atPoint: CGPoint(x:x,y:bounds.size.height - 20))
            addArc(atPoint: CGPoint(x:x,y:bounds.size.height - 25))
            bezierPath = nil
            bezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y:  bounds.size.height - 10 , width: bounds.size.width, height: 10), cornerRadius: 2)
            let secondMaskLayer = CAShapeLayer()
            secondMaskLayer.fillColor = fillColor.cgColor
            secondMaskLayer.path = bezierPath!.cgPath
            layer.addSublayer(secondMaskLayer)
        case .verticalDots:
            let p0 = CGPoint.init(x: 0, y: 0)
            let p1 = CGPoint.init(x: 0, y: bounds.size.height)
            addDashedBorder(p0: p0, p1: p1)
        case .horizontalDots:
            let p0 = CGPoint.init(x: 0, y: 0)
            let p1 = CGPoint.init(x:  bounds.size.width, y: 0)
            addDashedBorder(p0: p0, p1: p1)
        default:
            break
        }
    }
    
    func addArc(atPoint point : CGPoint) {
        let desiredLineWidth:CGFloat = 1
        let path = UIBezierPath.init(arcCenter: point, radius: 1.5, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        layer.addSublayer(shapeLayer)
    }
    
    func addDashedBorder(p0 : CGPoint, p1 : CGPoint, lineWidth : CGFloat = 1) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = dashedBorderLineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = dashedBorderLineDashPattern
        let path = CGMutablePath()
        path.addLines(between: [p0,p1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
