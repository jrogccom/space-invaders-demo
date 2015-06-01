//
//  AnalogStick.swift
//  Space Invaders Clone
//
//  Created by Javier Osorio on 5/26/15.
//  Copyright (c) 2015 Javier & Osorio. All rights reserved.
//

import UIKit

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrt(Float(a)))
}
    
#endif
@IBDesignable
class AnalogStick: UIControl {
    
    @IBInspectable var outerRadius : CGFloat = 30.0
    @IBInspectable var outerLineWidth : CGFloat = 10.0
    @IBInspectable var outerStrokeColor : UIColor = UIColor.redColor()
    
    @IBInspectable var innerRadius : CGFloat = 8.0
    @IBInspectable var innerLineWidth : CGFloat = 10.0
    @IBInspectable var innerStrokeColor : UIColor = UIColor.redColor()
    
    private var _touchPoint : CGPoint = CGPointZero
    private(set) var touchPoint : CGPoint {
        set (point) {
            _touchPoint = point
            self.setNeedsDisplay()
        }
        get {
            return _touchPoint
        }
    }
    
    var relativeTouchPoint : CGPoint {
        get {
            return touchPoint - boundsCenter
        }
    }

    var boundsCenter : CGPoint {
        get {
            return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        }
    }
    var touchDown = false
    var vectorPoint : CGPoint {
        get {
            return relativeTouchPoint / outerRadius
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        let inner = CGPathCreateMutable()
        let outer = CGPathCreateMutable()
        
        var analogCenter = touchDown ? touchPoint : boundsCenter
        
        CGPathAddArc(outer, UnsafePointer<CGAffineTransform>.null(), bounds.width / 2, bounds.height / 2, outerRadius, 0, CGFloat(2 * M_PI), true)
        CGPathAddArc(inner, UnsafePointer<CGAffineTransform>.null(), analogCenter.x, analogCenter.y, innerRadius, 0, CGFloat(2 * M_PI), true)
        
        CGContextAddPath(context, outer)
        CGContextSetStrokeColorWithColor(context, outerStrokeColor.CGColor)
        CGContextSetLineWidth(context, outerLineWidth)
        CGContextStrokePath(context)
        
        CGContextAddPath(context, inner)
        CGContextSetStrokeColorWithColor(context, innerStrokeColor.CGColor)
        CGContextSetLineWidth(context, innerLineWidth)
        CGContextStrokePath(context)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = UIColor.clearColor()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)
        if (pointInRadius(point: point - boundsCenter, radius: outerRadius)) {
            touchDown = true
            touchPoint = adjustedPointWithMaxDistanceToPoint(toPoint: point, fromPoint: boundsCenter, maxDist: outerRadius)
        }
//        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        touchPoint = adjustedPointWithMaxDistanceToPoint(toPoint: touch.locationInView(self), fromPoint: boundsCenter, maxDist: outerRadius)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        touchDown = false
        touchPoint = boundsCenter
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        touchDown = false
        touchPoint = boundsCenter
    }
    
    func adjustedPointWithMaxDistanceToPoint(#toPoint: CGPoint, fromPoint: CGPoint, maxDist: CGFloat) -> CGPoint {
        if (pow(toPoint.x - fromPoint.x, 2) + pow(toPoint.y - fromPoint.y, 2) < pow(maxDist, 2)) {
            return toPoint
        } else {
            let angle = atan2(toPoint.y - fromPoint.y, toPoint.x - fromPoint.x)
            return CGPoint(x: outerRadius * cos(angle) + fromPoint.x, y: outerRadius * sin(angle) + fromPoint.y)
        }
    }
    
    func pointInRadius (#point: CGPoint, radius: CGFloat) -> Bool {
        return pow(point.x, 2) + pow(point.y, 2) < pow(radius, 2)
    }

}
