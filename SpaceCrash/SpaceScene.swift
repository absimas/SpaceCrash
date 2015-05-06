//
//  SpaceScene.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 27/03/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

enum Direction {
    case None
    case Top
    case Bottom
    case Left
    case Right
}

// Preload sound actions
var laserSound : SKAction?


class SpaceScene : SKScene, Resizable, SKPhysicsContactDelegate {
    
    struct Mask {
        static let SCENE        = 0x1 << 1 as UInt32
        static let SPACE        = 0x1 << 2 as UInt32
        static let SPACE_SHIP   = 0x1 << 3 as UInt32
        static let ASTEROID     = 0x1 << 4 as UInt32
        static let LASER        = 0x1 << 5 as UInt32
    }
    let spaceShip       : SpaceShip
    let space           : Space
    let healthIndicator : HealthIndicator
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        // Initialize nodes
        spaceShip = SpaceShip()
        space = Space(size)
        healthIndicator = HealthIndicator()
        super.init(size: size)
            
        // Add nodes
        addChild(space)
        addChild(spaceShip)
        addChild(healthIndicator)
        
        resize()
        
        // Physics world
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    }
    
    override func didMoveToView(view: SKView) {
        // Preload sound
        laserSound = SKAction.playSoundFileNamed("LaserSound.mp3", waitForCompletion: false)
        
        // Begin the asteroid rain
        space.startAsteroidRain()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        // ToDo need to implement multiple clicks so can shoot and move at the same time?
        // Or shooting is a double / 2 finger click
        // Or shoot only when clicked on a a asteroid node
        // Select 1st touch
        let touch = touches.first as! UITouch
        
        // Determine East or West
        let direction = findDirection(spaceShip.position, touchPos: touch.locationInNode(self))
        
        // Execute movement
        spaceShip.move(direction)
        spaceShip.shoot()
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
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        spaceShip.stopMovement()
    }
    
    func resize() {
        // Resize Space (background)
        space.size = frame.size
        
        // Re-Position the SpaceShip // ToDo position only once, or position according to previous orientation
        spaceShip.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidX(frame) / 4)
        
        // Constrain the SpaceShip position, so it doesn't leave the screen
        let constraint = SKConstraint.positionX(SKRange(lowerLimit: spaceShip.frame.width / 2, upperLimit: frame.width - spaceShip.frame.width / 2))
        spaceShip.constraints = [constraint]

        // Resize Asteroids // Resize SpaceShip
        // Or let space resize its nodes
        
        // Health indicator position
        healthIndicator.position = CGPointMake(frame.size.width - HealthIndicator.Const.INDICATOR_SIZE.width,
            frame.size.height - HealthIndicator.Const.INDICATOR_SIZE.height)
    }
    
    func transitionToEndScene() {
        let doorsCloseX = SKTransition.doorsCloseHorizontalWithDuration(TRANSITION_DURATION)
        view?.presentScene(GameOverScene(size: frame.size), transition: doorsCloseX)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let aMask = contact.bodyA.categoryBitMask
        let bMask = contact.bodyB.categoryBitMask
        
        switch (aMask, bMask) {
        case (Mask.SPACE_SHIP, Mask.SCENE): fallthrough
        case (Mask.SCENE, Mask.SPACE_SHIP):
            // ToDo on collision with scene, space ship should stop moving
            return
        case (Mask.LASER, Mask.ASTEROID):
            if let laser = contact.bodyA.node as? Laser {
                laser.remove()
            }
            if let asteroid = contact.bodyB.node as? Asteroid {
                // ToDo run destruction animation instead
                asteroid.remove()
            }
        case (Mask.ASTEROID, Mask.LASER):
            if let laser = contact.bodyB.node as? Laser {
                laser.remove()
            }
            if let asteroid = contact.bodyA.node as? Asteroid {
                // ToDo run destruction animation instead
                asteroid.remove()
            }
        case (Mask.SPACE_SHIP, Mask.ASTEROID):
            if let asteroid = contact.bodyB.node as? Asteroid {
                // ToDo run destruction animation instead
                asteroid.remove()
            }
            // Take damage
            if !healthIndicator.decreaseHealth() {
                transitionToEndScene()
            }
        case (Mask.ASTEROID, Mask.SPACE_SHIP):
            if let asteroid = contact.bodyA.node as? Asteroid {
                // ToDo run destruction animation instead
                asteroid.remove()
            }
            // Take damage
            if !healthIndicator.decreaseHealth() {
                transitionToEndScene()
            }
        default:
            return
        }
    }
    
}
