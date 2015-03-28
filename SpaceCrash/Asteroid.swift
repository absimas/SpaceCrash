//
//  Asteroid.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 3/28/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

class Asteroid : SKSpriteNode {
    
    struct Const {
        static let MIN_RADIUS = 10 as CGFloat
        static let MAX_RADIUS = 50 as CGFloat
        static let SINGLE_MOVE_DURATION = 1 as NSTimeInterval
    }
    let TEXTURE_NAME = "Asteroid"
    
    // Computed property
    var moveBy: CGVector {
        get {
            return CGVectorMake(randInRange(-25, 25), -100)
        }
    }
    
    class func randomSized() -> Asteroid {
        // ToDo make sure frame.width - asteroid.width is not > than asteroid.width
            // i.e. make sure the randomness is correct
        let size = randInRange(Int(Const.MIN_RADIUS * 2), Int(Const.MAX_RADIUS * 2))
        return Asteroid(size: CGSizeMake(size, size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: TEXTURE_NAME), color: nil, size: size)
        // Physics
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.categoryBitMask = SpaceScene.Mask.ASTEROID
        physicsBody!.contactTestBitMask = SpaceScene.Mask.ASTEROID | SpaceScene.Mask.SPACE_SHIP
        physicsBody!.collisionBitMask = SpaceScene.Mask.ASTEROID | SpaceScene.Mask.SPACE_SHIP
    }
    
    func startMovement() {
        // ToDo can change dx dy after each sequence i.e. non constant meteors

        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.moveBy(moveBy, duration: Const.SINGLE_MOVE_DURATION),
            SKAction.runBlock({
                if self.position.y < 0 {
                    self.remove()
                }
            })
        ])))
    }
    
    func remove() {
        self.removeFromParent()
        self.removeAllActions()
    }

}
