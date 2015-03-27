//
//  SpaceScene.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 27/03/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

enum Direction {
    case Top
    case Bottom
    case Left
    case Right
}

class SpaceScene : SKScene, Resizable, SKPhysicsContactDelegate {
    
    let spaceShip : SpaceShip
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        // Initialize nodes
        spaceShip = SpaceShip()
        super.init(size: size)
        // Disable gravity
        physicsWorld.gravity = CGVectorMake(0, 0)
        // Set contact delegate
        physicsWorld.contactDelegate = self
    }
    
    override func didMoveToView(view: SKView) {
        // Add SpaceShip
        spaceShip.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidX(view.frame))
        addChild(spaceShip)
    }
    
    func resize() {
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // ToDo need to implement multiple clicks so can shoot and move at the same time?
            // Or shooting is a double / 2 finger click
            // Or shoot only when clicked on a a asteroid node
        // Select 1st touch
        let touch = touches.allObjects[0] as UITouch
        
        // Determine East or West
        let direction = findDirection(spaceShip.position, touchPos: touch.locationInNode(self))
        
        // Execute movement
        spaceShip.move(direction)
    }
    
    
    func findDirection(mainPos: CGPoint, touchPos: CGPoint) -> Direction {
        // East or West
        let diff = touchPos.x - mainPos.x
        if abs(diff) != diff {
            // touchPos.x < nodePos.x => East
            return Direction.Left
        } else {
            return Direction.Right
        }
    }

    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        spaceShip.stopMovement()
    }
    
}
