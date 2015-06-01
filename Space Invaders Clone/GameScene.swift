//
//  GameScene.swift
//  Space Invaders Clone
//
//  Created by Javier Osorio on 5/22/15.
//  Copyright (c) 2015 Javier & Osorio. All rights reserved.
//

import SpriteKit


let playerSpriteName : String = "ship_1"

struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Bogie : UInt32 = 0b1
    static let Item : UInt32 = 0b10
}

enum MoveDirection {
    case Left
    case Right
    case None
    
    func sense() -> Int {
        switch self {
        case .Left:
            return -1
        case .Right:
            return 1
        default:
            return 0
        }
    }
}
class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: playerSpriteName)
    
    let analog : AnalogStick = AnalogStick()
    
    var direction = MoveDirection.None
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        player.position = CGPoint(x: size.width / 2, y: size.width * 0.1)
        addChild(player)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            direction = directionForTouch(location)
            
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch : AnyObject in touches {
            
            let location = touch.locationInNode(self)
            direction = directionForTouch(location)
            
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        for touch : AnyObject in touches {
            
            direction = MoveDirection.None
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let moveDist = 10
        let moveTime = 0.2
        let moveAction = SKAction.moveBy(CGVector(dx: CGFloat(moveDist * direction.sense()), dy: 0.0), duration: moveTime)
        player.runAction(moveAction)
    }
    
    func directionForTouch(touchPoint: CGPoint) -> MoveDirection {
        
        var leftRect = CGRectZero
        var rightRect = CGRectZero
        
        CGRectDivide(self.frame, &leftRect, &rightRect, CGRectGetWidth(self.frame) / 2, CGRectEdge.MinXEdge)
        
        if leftRect.contains(touchPoint) {
            return MoveDirection.Left
        } else {
            return MoveDirection.Right
        }
    }
}
