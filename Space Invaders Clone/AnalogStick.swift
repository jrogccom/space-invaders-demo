//
//  AnalogStick.swift
//  Space Invaders Clone
//
//  Created by Javier Osorio on 5/26/15.
//  Copyright (c) 2015 Javier & Osorio. All rights reserved.
//

import UIKit

@IBDesignable
class AnalogStick: UIControl {
    
    @IBInspectable var outerRadius : CGFloat = 30.0
    @IBInspectable var outerLineWidth : CGFloat = 10.0
    @IBInspectable var outerStrokeColor : UIColor = UIColor.redColor()
    
    @IBInspectable var innerRadius : CGFloat = 8.0
    @IBInspectable var innerLineWidth : CGFloat = 10.0
    @IBInspectable var innerStrokeColor : UIColor = UIColor.redColor()
    
    var touchPoint = CGPoint(x: CGFloat.NaN, y: CGFloat.NaN)
    var touchDown = false
    
    var vector : CGVector {
        get {
            return CGVector(dx: 0, dy: 0)
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        let inner = CGPathCreateMutable()
        let outer = CGPathCreateMutable()
        
        var analogCenter = touchDown ? touchPoint : CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        CGPathAddArc(outer, UnsafePointer<CGAffineTransform>.null(), bounds.width / 2, bounds.height / 2, outerRadius, 0, CGFloat(2 * M_PI), true)
        CGPathAddArc(inner, UnsafePointer<CGAffineTransform>.null(), analogCenter.x, analogCenter.y, innerRadius, 0, CGFloat(2 * M_PI), true)
        
        CGContextAddPath(context, inner)
        CGContextSetStrokeColorWithColor(context, innerStrokeColor.CGColor)
        CGContextSetLineWidth(context, innerLineWidth)
        CGContextStrokePath(context)
        
        CGContextAddPath(context, outer)
        CGContextSetStrokeColorWithColor(context, outerStrokeColor.CGColor)
        CGContextSetLineWidth(context, outerLineWidth)
        CGContextStrokePath(context)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = UIColor.clearColor()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        touchDown = true
        let touch = touches.anyObject() as UITouch
        touchPoint = touch.locationInView(self)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        touchDown = false
    }

}
