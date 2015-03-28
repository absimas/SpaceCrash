//
//  Space.swift
//  SpaceCrash
//
//  Created by Simas Abramovas on 3/28/15.
//  Copyright (c) 2015 Simas Abramovas. All rights reserved.
//

import SpriteKit

class Space : SKSpriteNode {
    
    let ASTEROID_RAIN_DELAY = 0.5 as NSTimeInterval
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ size : CGSize) {
        // ToDo space tiled textures
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
        anchorPoint = CGPointMake(0, 0)
        // Physics
        println(frame)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody!.categoryBitMask = SpaceScene.Mask.SCENE
        physicsBody!.contactTestBitMask = SpaceScene.Mask.SCENE | SpaceScene.Mask.SPACE_SHIP
        physicsBody!.collisionBitMask = SpaceScene.Mask.SCENE | SpaceScene.Mask.SPACE_SHIP
    }
    
    func addRandomAsteroid() {
        // ToDo width when orientation landscape
        
        // Create a random sized Asteroid
        let asteroid = Asteroid.randomSized()
        
        // Random position based on the size of the asteroid
        let x = randInRange(Int(asteroid.size.width), Int(frame.size.width - asteroid.size.width))
        let y = frame.size.height + asteroid.size.height
        asteroid.position = CGPointMake(x, y)
        
        // Start moving the new asteroid
        addChild(asteroid)
        asteroid.startMovement()
    }
    
    func startAsteroidRain() {
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.addRandomAsteroid()
            }),
            SKAction.waitForDuration(ASTEROID_RAIN_DELAY)
        ])))
    }
    
}